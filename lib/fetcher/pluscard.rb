module Fetcher
  
  class Pluscard < Base
    
    START = 'https://www.pluscard.de/kris/anmeldung/anmeldung.php'
    
    def login
      page  = get(START)
      form  = page.form("login")
      form.krednr   = @account.username
      form.kennwort = @account.password
      
      # Einloggen
      page = form.submit
      
      # Login fehlgeschlagen?
      raise LoginException if page.uri.path != '/kris/saldo/index.php'
      
      @numbers = page.search("input[name=krednr]").collect{|input| input["value"] }
      
      raise ArgumentError, "Keine Kreditkarten gefunden" if @numbers.empty?
    end
    
    def list
      invoices = []
      
      for number in @numbers
        select_card number
        page = get '/kris/abrechnung/index.php'
        rows = page.at!("table[cellspacing='1']").children
        
        # spaltenüberschriften entfernen
        rows.shift
        
        for row in rows
          link = row.at!("a")
          href = link['href']
          date = row.search("./td")[1].text
          
          if href =~ /neue_abrechnung/
            # zwischenseite aufrufen *seufz*
            page = get href
            link = page.links.find{|l| l.href =~ /\/download\/.+\.pdf$/}
            href = link.href
          end
          
          invoices << build_invoice(
            :href   => href + "|" + number,
            :number => href.match(/(xxx[^\/]+)\.pdf/)[1],
            :date   => date
          )
        end
      end
      
      invoices
    end
    
    def logout
      get '/kris/abmelden/index.php'
    end
    
    def download(invoice,href)
      download_url, number = href.split("|")
      select_card number
      get download_url
    end
    
    protected
    
    # Wählt eine Kreditkarte aus, die ausgewählte wird in der Session gespeichert
    def select_card(number)
      get '/kris/common/navigation.php?abrechnung_neu=J&krednr=' + number
    end
    
    def get(path)
      super path.sub(/^\.\./,'/kris')
    end
    
  end
  
end