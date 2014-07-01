require File.expand_path('../../../config/environment',  __FILE__)

class Rename < Thor
  desc "app", "Rename the application"
  def app(name="")
    answer = ask "Rename DefaultApp application to #{name.camelize} ?(yes/no)"

    if answer != "yes"
      puts "You didn't accept ! Exiting ...."
      exit 1
    end

    puts "Renaming application"

    app_file=Rails.root.join('config', 'application.rb')
    modify_content(app_file, "module DefaultApp", "module #{name.camelize}")

    init_file=Rails.root.join('config', 'initializers', 'session_store.rb')
    modify_content(init_file, "default_app_session", "#{name.underscore}_session")
  end

  no_commands do
    def modify_content(file, pattern, new_text)
      if not File.writable?(file)
        puts "ERROR: unable to obtain write permissions on #{file} !"
        puts "Verify file path and permissions. Exiting..."
        exit 2
      end

      puts "Modifying #{file}"
      puts "Backuping file to #{file}.bkp"
      FileUtils.cp "#{file}", "#{file}.bkp"
      content = File.read(file)
      new_content = content.gsub!(/#{pattern}/, new_text)

      if new_content.nil?
        puts "Unable to modify file ! Exiting..."
        exit 3
      end

      File.open(file, 'w') { |file| file.write(new_content) }
      puts "File modified !"
    end
  end
end
