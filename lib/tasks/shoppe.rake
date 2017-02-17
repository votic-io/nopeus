namespace :shoppe do
  desc 'Load seed data for the Shoppe'
  task :seed, [:application_name] => :environment do |task, args|
    name = args[:application_name]
    application = Shoppe::Application.where(name: name).first_or_create
    Thread.current[:application] = application
  
    require File.join(Shoppe.root, 'db', 'seeds')
  end

  desc 'Create a default admin user'
  task :create_default_user, [:application_name] => :environment do |task, args|
    name = args[:application_name]
    application = Shoppe::Application.where(name: name).first_or_create
    Thread.current[:application] = application
    
    Shoppe::User.create(email_address: "admin@#{Thread.current[:application].name}.com", password: 'password', password_confirmation: 'password', first_name: 'Default', last_name: 'Admin')
    puts
    puts '    New user has been created successfully.'
    puts
    puts "    E-Mail Address..: admin@#{Thread.current[:application].name}.com"
    puts '    Password........: password'
    puts
  end

  desc 'Import default set of countries'
  task :import_countries, [:application_name] => :environment do |task, args|
    name = args[:application_name]
    application = Shoppe::Application.where(name: name).first_or_create
    Thread.current[:application] = application

    Shoppe::CountryImporter.import
  end

  desc 'Run the key setup tasks for a new application'
  task setup: :environment do

    application = Shoppe::Application.where(name: 'default').first_or_create
    Thread.current[:application] = application

    puts "--------------------------asdasdasd"

    puts Thread.current[:application].to_json

    Rake.application.invoke_task("shoppe:import_countries[#{application.name}]")    if Shoppe::Country.all.empty?
    Rake.application.invoke_task("shoppe:create_default_user[#{application.name}]") if Shoppe::User.all.empty?

    Rake.application.invoke_task("shoppe:seed[#{application.name}]")
  end

  desc 'Converts nifty-attachment attachments to Shoppe Attachments'
  task attachments: :environment do
    require 'nifty/attachments'

    attachments = Nifty::Attachments::Attachment.all

    attachments.each do |attachment|
      object = attachment.parent_type.constantize.find(attachment.parent_id)

      attach = object.attachments.build
      attach.role = attachment.role
      attach.file_name = attachment.file_name

      tempfile = Tempfile.new("attach-#{attachment.token}")
      tempfile.binmode
      tempfile.write(attachment.data)
      uploaded_file = ActionDispatch::Http::UploadedFile.new(tempfile: tempfile, filename: attachment.file_name, type: attachment.file_type)

      attach.file = uploaded_file
      attach.save!
    end
  end

  desc 'Converts nifty-attachment attachments to Shoppe Attachments'
  task :create_application, [:application_name] => :environment do |task, args|
    name = args[:application_name]
    application = Shoppe::Application.where(name: name).first_or_create
    Thread.current[:application] = application

    Rake.application.invoke_task("shoppe:import_countries[#{application.name}]")    if Shoppe::Country.all.empty?
    Rake.application.invoke_task("shoppe:create_default_user[#{application.name}]") if Shoppe::User.where(application_id: application.id).empty?

    Rake.application.invoke_task("shoppe:seed[#{application.name}]")
  end
end
