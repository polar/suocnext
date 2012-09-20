class Comatose::PageVersion < ActiveRecord::Base
end
class ClubMember < User
end

class UpgradeToSuoc20 < ActiveRecord::Migration
  def up

    change_table :comatose_pages do |t|
      t.timestamps
      t.string :mount
      t.attachment :photo
    end

    change_table :page_photos do |t|
      t.integer :comatose_page_id
    end

    change_table :comatose_page_versions do |t|
      t.string :mount
      t.rename :comatose_page_id, :page_id
    end

    puts "-- Migrating Comatose::Page #{Comatose::Page.count} to Paperclip"
    Comatose::Page.all().each do |p|
      putc "."
      p.mount = "/home"
      page_photo = PagePhoto.where(:id => p.page_photo_id).first
      if (page_photo)
        p.photo_file_name = page_photo.filename
        p.photo_content_type = page_photo.content_type
        p.photo_file_size = page_photo.size
        page_photo.comatose_page_id = p.id
        page_photo.save
        puts p.photo_file_name
      end
      p.save
    end
    puts "\n  -> Done."

    match=/img src=\"\/photos\/0000\/([0-9]+)\/([0-9\.\w\-_]+)(|_((small|medium|large|thumb)))\.([\w]+)\"/
    def replace_image(match, rp)
      while (m1 = match.match rp)
        p m1
        m2 = /(_(small|medium|large|thumb))/.match m1[2]
        p m2
        if (m2)
          style = m2[2]
          name = m1[2].gsub(m2[1], "")
        else
          style = "original"
          name = m1[2]
        end
        id = m1[1].to_i # reduces it from 4 digits
        rp = rp.gsub(m1[0], "img src=\"/system/photos/#{id}/#{style}/#{name}.#{m1[6]}\"")
      end
      rp
    end

    posts = Post.all.select {|p| match =~ p.post || match =~ p.raw_post }

    puts "-- Migrating Posts with Photos #{posts.size}"
    posts.each do |p|
      putc "."
      p.raw_post = replace_image(match, p.raw_post)
      p.post = replace_image(match, p.post)
      p.save
    end
    puts "\n  -> Done."

    def replace(attachment, d, &block)
      puts "-- Migrating #{attachment} files"
      match = /(_(small|medium|large|thumb))\.([\w]+)/
      d.entries.each do |entry|
        if !(/^\./ =~ entry)
          if block_given?
            id = block.call(entry)
          else
            id = entry.to_i.to_s
          end
          next if id.nil? || id.blank?


          FileUtils.mkdir_p("#{attachment}/#{id}/original")
          FileUtils.mkdir_p("#{attachment}/#{id}/small")
          FileUtils.mkdir_p("#{attachment}/#{id}/medium")
          FileUtils.mkdir_p("#{attachment}/#{id}/large")
          FileUtils.mkdir_p("#{attachment}/#{id}/thumb")
          tod = Dir.new(File.join(d.to_path, entry))
          puts "#{File.join(d.to_path, entry)} #{tod.entries.inspect}"
          tod.entries.each do |file|
            if !(/^\./ =~ file)
              m1 = match.match file
              if (m1)
                style = m1[2]
                fname = file.gsub(m1[1],"")
              else
                style = "original"
                fname = file
              end
              src = File.join(File.join(d.to_path,entry),file)
              dst = "#{attachment}/#{id}/#{style}/#{fname}"
              puts "      #{src} ==> #{dst}"
              FileUtils.move(src, dst)
            end
          end
        end
      end
      puts "\n   -> Done."
      nil
    end

    replace("public/system/photos", Dir.new("public/photos/0000"))
    replace("public/system/comatose/home/pages/photos", Dir.new("public/page_photos/0000")) { |e| PagePhoto.find(e).comatose_page_id }

    FileUtils.rm("public/photos", :force => true)
    FileUtils.rm("public/page_photos", :force => true)

    change_table :comatose_pages do |t|
      t.remove :author
      t.remove :page_photo_id
    end

    change_table :comatose_page_versions do |t|
      t.remove :page_photo_id
    end

    drop_table :page_photos

  end

  def down
  end
end
