class Privilege < OpenMRS
  set_table_name "privilege"
  set_primary_key "privilege_id"

  has_many :role_privileges, :foreign_key => :privilege_id, :dependent => :delete_all
  has_many :roles, :through => :role_privileges
end
