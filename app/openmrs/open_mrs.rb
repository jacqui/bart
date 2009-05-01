class OpenMRS < ActiveRecord::Base
  self.abstract_class = true

  def before_save
    super
    # TODO: add warning or raise exception when there's no User.current_user
    if self.attributes.has_key?("changed_by") && User.current_user
      self.changed_by = User.current_user.user_id
    end
    if self.attributes.has_key?("date_changed")
      self.date_changed = Time.now
    end
  end

  def before_create
    super
    if self.attributes.has_key?("creator") && User.current_user
      self.creator = User.current_user.user_id
    end
    if self.attributes.has_key?("date_created")
      self.date_created = Time.now
    end
    if self.attributes.has_key?("location_id") && self.location_id == 0 && Location.current_location
      self.location_id = Location.current_location.location_id
    end
  end

  def void!(reason)
    void(reason)
    save!
  end

  def void(reason)
    # TODO right now we are not allowing voiding to work on patient_identifiers
    # because of the composite key problem. Eventually this needs to be replaced
    # with better logic (like person_attributes)

    #   TODO: this needs testing before turning on. For now, don't void Patient Identifiers
    #    if composite?
    #      destroy
    #      return
    #    end
    unless voided?
      self.date_voided = Time.now
      self.voided = true
      self.void_reason = reason
      self.voided_by = User.current_user.user_id unless User.current_user.nil?
    end
  end

  def voided?
    self.attributes.has_key?("voided") ? voided : raise("Model does not support voiding")
  end

  # cloning when there are composite primary keys
  # will delete all of the key attributes, we don't want that
  def composite_clone
    if composite?
      attrs = self.attributes_before_type_cast
      self.class.new do |record|
        record.send :instance_variable_set, '@attributes', attrs
      end
    else
      clone
    end
  end

  def self.find_like_name(name)
    self.find(:all, :conditions => ["name LIKE ?","%#{name}%"])
  end

  def self.cache_on(*args)
    self.cattr_accessor :cached
    self.cached = true
  end

  def self.cached?
    self.cached
  end
end
