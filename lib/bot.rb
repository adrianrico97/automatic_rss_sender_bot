require 'rss'
require 'telegram/bot'
require 'yaml'
require_relative '../app/models/posted_new'

class Bot
  ############################################################
  # CONSTRUCTOR
  ############################################################
  def initialize(token, channel_id, rss_feed_url)
    @token = token
    @channel_id = channel_id
    @rss_feed_url = rss_feed_url
  end

  ############################################################
  # INSTANCE METHODS
  ############################################################

  # Lee el feed RSS y publica los títulos de las noticias en el canal
  def post_news
    rss = RSS::Parser.parse(@rss_feed_url)
    begin
      rss.items.each do |item|
        # Verifica si la noticia ya ha sido enviada
        unless sent_new?(item)
          item_txt = prepare_item_txt(item)
          send_message(empty_text(item_txt))
          add_sent_news(item)
        end
      end
      {"ok" => true}
    rescue Telegram::Bot::Exceptions::ResponseError => e
      # A veces ocurre un Too Many Requests cuando hay muchas noticias que enviar
      # Se recupera el error, se imprime y las noticias pendientes se enviarán
      # en la siguiente ronda
      puts "ERROR: #{e}"
      JSON.parse(e.response.body)
    end
  end

  ############################################################
  # PRIVATE METHODS
  ############################################################
  private
  # Función para enviar mensajes al canal
  def send_message(message)
    Telegram::Bot::Client.run(@token) do |bot|
      bot.api.send_message(chat_id: @channel_id, text: message, parse_mode: 'html')
    end
  end

  # Comprueba en BB.DD. si una noticia ya fue enviada
  def sent_new?(item)
    PostedNew.where(channel_identifier: @channel_id).find_by_link(item.link).present?
  end

  # Función para agregar una noticia al archivo de noticias ya enviadas
  def add_sent_news(item)
    # Guardamos en BB.DD el envío
    PostedNew.create!(
      title: item.title,
      link: item.link,
      posted_at: Time.now,
      channel_identifier: @channel_id
    )
  end

  # Elimina elementos no válidos del texto para Telegram
  def empty_text(txt)
    if txt.include?("<span")
      txt = txt.gsub('<span lang="gl">',"").gsub("</span>","")
    end
    if txt.include?("<p>")
      txt = txt.gsub('<p>',"").gsub("</p>","")
    end
    txt
  end

  # Redacta el cuerpo del mensaje a enviar a Telegram
  def prepare_item_txt(item)
    txt = ""
    if item.title
      txt << "<b>#{item.title}</b>"
      txt << "\n\n"
    end
    unless item.description.strip.empty?
      txt << "<i>#{item.description.strip}</i>"
      txt << "\n\n"
    end
    if item.link
      txt << item.link
    end
    txt
  end

end
