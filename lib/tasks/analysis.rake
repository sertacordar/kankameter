namespace :instela do
  desc "TODO"
  task analysis: :environment do

    require 'rest-client'

    # rake demo:analysis user_id=103949 limit=5

    user_id = ENV['user_id']
    limit = ENV['limit']

    unless user_id.nil?
      favourites = User.find(user_id).favourites
      result = Hash.new { |h, k| h[k] = []  }
      favourites.each do |fav|
        result[fav.faved_by].push(fav.entry_id)
      end

      result = result.sort_by {|_, array| array.count}.reverse

      puts "_=_=_=_=_=_=_=_=_=_=_=_=_=_=_=_=_=_=_=_=_=_=_=_=_=_=_=_"
      puts "Veritabanı || İlk entry tarihi: #{Entry.first.entry_last_modified}"
      puts "Veritabanı || Son entry tarihi: #{Entry.last.entry_last_modified}"
      puts "_=_=_=_=_=_=_=_=_=_=_=_=_=_=_=_=_=_=_=_=_=_=_=_=_=_=_=_"
      puts "Favlanan: #{User.find(user_id).username} || Toplam Entry: #{User.find(user_id).entries.count} || Toplam Fav: #{User.find(user_id).favourites.count}"
      puts "_=_=_=_=_=_=_=_=_=_=_=_=_=_=_=_=_=_=_=_=_=_=_=_=_=_=_=_"
      puts "Fav/Entry = #{(User.find(user_id).favourites.count.to_f/User.find(user_id).entries.count.to_f).round(2)} || Fav Alınan Yazar Sayısı: #{result.size}"
      puts "_=_=_=_=_=_=_=_=_=_=_=_=_=_=_=_=_=_=_=_=_=_=_=_=_=_=_=_"
      puts "En çok favlayan ilk #{limit} kişi:"

      result.first(limit.to_i).each do |key, array|
        if User.exists? key
          puts "Favlayan: #{User.find(key).username} || Fav: #{array.count}"
        else
          puts "Favlayan: #{key} || Fav: #{array.count}"
        end
      end
      puts "_=_=_=_=_=_=_=_=_=_=_=_=_=_=_=_=_=_=_=_=_=_=_=_=_=_=_=_"
    end
  end
end
