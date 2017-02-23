class AddLdapScoringPorts < ActiveRecord::Migration[5.0]
  def change
    rename_column :ml_scoring_services, :port, :ldap_port
    add_column :ml_scoring_services, :scoring_port, :integer
  end
end
