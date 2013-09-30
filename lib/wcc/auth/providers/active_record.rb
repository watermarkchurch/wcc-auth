module WCC::Auth::Providers::ActiveRecord

  module ClassMethods

    def credential_data_mapping(oauth_data)
      {
        email: oauth_data.info.email,
        first_name: oauth_data.info.first_name,
        last_name: oauth_data.info.last_name,
        access_token: oauth_data.credentials.token,
      }
    end

    def initialize_from_watermark_oauth(oauth_data)
      find_or_initialize_by(provider: :watermark, uid: oauth_data.uid) do |user|
        user.assign_attributes(credential_data_mapping(oauth_data))
      end
    end

  end

  module InstanceMethods

  end

  def self.included(receiver)
    receiver.send :extend, ClassMethods
    receiver.send :include, InstanceMethods
  end

end

