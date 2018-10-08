module ManageIQ::Providers::Lenovo::PhysicalInfraManager::PhysicalServer::Operations
  extend ActiveSupport::Concern

  include_concern 'ManageIQ::Providers::Lenovo::PhysicalInfraManager::Operations::ComponentAnsibleSender'

  #
  #
  #
  def provision_server(config_pattern_id)
    ansible_update_firmware
    ansible_apply_pattern(config_pattern_id)
  end

  def ansible_update_firmware
    run_ansible({
      'role_name' => 'lenovo.lxca-config',
      'tags'      => 'update_all_firmware_withpolicy',
      'vars'      => {
        'mode'      => 'immediate',
        'uuid_list' => uid_ems,
        'lxca_action' => 'apply'
      }
    })
  end

  def ansible_update_firmware(firmware_names = [])
    run_ansible({
      'role_name' => 'lenovo.lxca-config',
      'tags'      => 'update_firmware',
      'vars'      => {
        'mode'      => 'immediate',
        'server' => "#{uid_ems},#{firmware_names.join(',')}",
        'lxca_action' => 'apply'
      }
    })
  end

  def ansible_apply_pattern(pattern_id)
    run_ansible({
      'role_name' => 'lenovo.lxca-config',
      'tags'      => 'apply_configpatterns',
      'vars' => {
        'endpoint'  => self.uid_ems,
        'restart'   => 'immediate',
        'type'      => 'node',
        'id'        => pattern_id
      }
    })
  end
end
