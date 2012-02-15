class Mail < ActiveRecord::Base

  def self.consumer_key
    "mail1up.com"
  end

  def self.consumer_secret
    ""
  end

  def write_config_files(auth_file, mbsync_config)
    dir_name = '/media/s3ql/' + self.mail
    Dir::mkdir(dir_name) unless FileTest::directory?(dir_name)
    Dir::mkdir(dir_name + '/Mail') unless FileTest::directory?(dir_name + "/Mail")
    File.open(dir_name + '/xoauth.sh', "w+") do |f|
      f.write(auth_file)
      f.chmod(0755)
    end
    File.open(dir_name + '/mbsync.config', "w+") do |f|
      f.write(mbsync_config)
      f.chmod(0755)
    end
    FileUtils.cp Rails.root + 'lib/xoauth.py', dir_name
  end
end
