require 'rss'
require 'telegram/bot'
require 'yaml'
require 'nokogiri'
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
    # False parameter avoid the validation: https://github.com/ruby/rss/issues/43
    rss = RSS::Parser.parse(@rss_feed_url, false)
    begin
      rss.items.each do |item|
        # Verifica si la noticia ya ha sido enviada
        unless sent_new?(item)
          item_txt = prepare_item_txt(item)
          send_message(item_txt)
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
  rescue RSS::NotWellFormedError => e
    # Error porque el feed RSS no está bien formado
    puts "ERROR en URL '#{@rss_feed_url}': #{e.message}"
    puts e.backtrace.join("\n")
    {"ok" => false}
  rescue StandardError => e
    # Error general
    puts "ERROR: #{e.message}"
    puts e.backtrace.join("\n")
    {"ok" => false}
  end

  ############################################################
  # PRIVATE METHODS
  ############################################################
  private

  def get_link(item)
    if item.is_a?(RSS::Atom::Feed::Entry)
      item.link.href
    else
      item.link
    end
  end

  def get_title(item)
    if item.is_a?(RSS::Atom::Feed::Entry)
      item.title.content
    else
      item.title
    end
  end

  # Función para enviar mensajes al canal
  def send_message(message)
    Telegram::Bot::Client.run(@token) do |bot|
      bot.api.send_message(chat_id: @channel_id, text: message, parse_mode: 'html')
    end
  end

  # Comprueba en BB.DD. si una noticia ya fue enviada
  def sent_new?(item)
    PostedNew.where(channel_identifier: @channel_id).find_by_link(get_link(item)).present?
  end

  # Función para agregar una noticia al archivo de noticias ya enviadas
  def add_sent_news(item)
    # Guardamos en BB.DD el envío
    PostedNew.create!(
      title: get_title(item),
      link: get_link(item),
      posted_at: Time.now,
      channel_identifier: @channel_id
    )
  end

  # Elimina elementos no válidos del texto para Telegram
  def empty_text(txt)
    Nokogiri::HTML(txt).content
  end

  # Redacta el cuerpo del mensaje a enviar a Telegram
  def prepare_item_txt(item)
    txt = ""
    if get_title(item)
      txt << "<b>#{empty_text(get_title(item))}</b>"
      txt << "\n\n"
    end
    if item.respond_to?(:description)
      unless item.description.strip.empty?
        txt << "<i>#{empty_text(item.description.strip)}</i>"
        txt << "\n\n"
      end
    end
    if get_link(item)
      txt << get_link(item)
    end
    txt
  end

end
