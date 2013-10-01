module WCC::Auth::Providers::ActiveRecord

  module ClassMethods

    def credential_data_mapping(oauth_data)
      {
        email: oauth_data.info.email,
        first_name: oauth_data.info.first_name,
        last_name: oauth_data.info.last_name,
        access_token: oauth_data.credentials.token,
        access_level_id: oauth_data.info.access_level_id,
      }
    end

    def initialize_from_watermark_oauth(oauth_data)
      find_or_initialize_by(provider: :watermark, uid: oauth_data.uid).tap do |user|
        user.assign_attributes(credential_data_mapping(oauth_data))
      end
    end

  end

  module InstanceMethods

    def access_level
      WCC::Auth::AccessLevel[access_level_id || :none]
    end

    def has_access?(level)
      access_level >= WCC::Auth::AccessLevel[level]
    end

  end

  def self.included(receiver)
    receiver.send :extend, ClassMethods
    receiver.send :include, InstanceMethods
  end

end

