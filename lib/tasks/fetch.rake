namespace :instela do
  desc "TODO"
  task fetch: :environment do

    require 'rest-client'

    (Entry.first.id+10).downto(1) do |i| # İlk çalıştırmada kafa karıştırır.
                                         # Halihazırda DB'de veri olduğu için böyle bir yola gittim.
                                         # 'Entry.first.id+10' dan başlayıp '1' e kadar git diyor. (decremental)
                                         # İlk çalıştırmada 'Entry.first.id+10' yerine elle bir sayı
                                         # (en son yazılmış entry-nin ID-si) verin.
      begin
        entry = RestClient.get("https://instela.com/api/v2/entries/#{i}")
        favourite = RestClient.get("https://instela.com/api/v2/entries/#{i}/favourites")


      unless User.exists?(id: JSON.parse(entry)['entries'].first['user']['id'])
        User.create(id: JSON.parse(entry)['entries'].first['user']['id'],
                    username: JSON.parse(entry)['entries'].first['user']['username'])
        puts "OK: USER || #{JSON.parse(entry)['entries'].first['user']['id']}"
      end

      unless Entry.exists?(id: JSON.parse(entry)['entries'].first['id'] )
        Entry.create(id: JSON.parse(entry)['entries'].first['id'],
                     user_id: JSON.parse(entry)['entries'].first['user']['id'],
                     entry_last_modified: JSON.parse(entry)['entries'].first['updated_at'].to_datetime)
        puts "OK: ENTRY || #{JSON.parse(entry)['entries'].first['id']}"
      end

      JSON.parse(favourite)['favourites'].each do |fav|
        unless Favourite.exists?(id: fav['id'])
          Favourite.create(id: fav['id'],
                           entry_id: JSON.parse(entry)['entries'].first['id'],
                           faved_by: fav['user']['id'])
          puts "OK: FAV || #{fav['id']}"
        end
      end
      rescue => error
        puts "ERROR: #{error} || #{i}"
      end
    end

  end
end
