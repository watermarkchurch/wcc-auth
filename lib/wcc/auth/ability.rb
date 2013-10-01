require 'cancan'

class WCC::Auth::TieredAbility
  include CanCan::Ability

  def initialize(user)
    @user = user
    grant_access_at(@user.access_level)
  end

  def grant_access_at(access_level)
    levels.each do |level, can_blocks|
      if access_level >= level
        can_blocks.each { |can_block| instance_exec(@user, &can_block) }
      end
    end
  end

  def levels
    self.class.levels
  end

  def self.at_level(level, &can_block)
    levels[WCC::Auth::AccessLevel[level]] << can_block
  end

  def self.levels
    @levels ||= Hash.new { |hash, key| hash[key] = [] }
  end

  def self.inherited(subclass)
    subclass.send :instance_variable_set, :@levels, levels.dup
  end
end
