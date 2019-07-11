// Scaleway library usage example: three-nodes Kubernetes cluster
local scw = import 'scaleway.libjsonnet';

{
  provider: {
    scaleway: scw.Scaleway {
      region: 'par1',
      organization: '',
      token: '',
    },
  },

  data: {
    scaleway_image: {
      ubuntu: scw.ScalewayImage {
        architecture: 'x86_64',
        name: 'Ubuntu Bionic',
        most_recent: true,
      },
    },
  },

  resource: {
    scaleway_server: {
      master:: scw.ScalewayServer {
        image: '${data.scaleway_image.ubuntu.id}',
        type: 'DEV1-S',
        tags::: ['kubernetes', 'master'],
        security_group::: '${scaleway_security_group.master.id}',

        dynamic_ip_required::: true,
      },
      worker:: scw.ScalewayServer {
        image: '${data.scaleway_image.ubuntu.id}',
        type: 'C2S',
        tags::: ['kubernetes', 'worker'],
        security_group::: '${scaleway_security_group.worker.id}',

        volume::: [
          // - /var/run
          scw.ScalewayAttachedVolume {
            type: 'l_ssd',
            size_in_gb: 50,
          },
          // - /var/volumes
          scw.ScalewayAttachedVolume {
            type: 'l_ssd',
            size_in_gb: 150,
          },
        ],

        // cloudinit: "TODO(ani): mount volume here"
      },

      master_01: self.master { name: 'master_01' },
      worker_01: self.worker { name: 'worker_01' },
      worker_02: self.worker { name: 'worker_02' },
    },

    scaleway_security_group: {
      master: scw.ScalewaySecurityGroup {
        name: 'kubernetes_master',
        description: 'Security group for kubernetes master node',
        stateful: true,
        inbound_default_policy::: 'drop',
        outbound_default_policy::: 'accept',
      },
      worker: scw.ScalewaySecurityGroup {
        name: 'kubernetes_worker',
        description: 'Security group for kubernetes master worker',
        stateful: true,
        inbound_default_policy::: 'drop',
        outbound_default_policy::: 'accept',
      },
    },

    scaleway_security_group_rule: {
      accept_all_from_internal:: scw.ScalewaySecurityGroupRule {
        action: 'accept',
        direction: 'inbound',
        protocol: 'TCP',
        ip_range: '10.0.0.0/8',
      },
      accept_all_from_external:: scw.ScalewaySecurityGroupRule {
        action: 'accept',
        direction: 'inbound',
        protocol: 'TCP',
        ip_range: '0.0.0.0/0',
      },
      accept_ping_from_external:: self.accept_all_from_external {
        protocol: 'ICMP',
      },
      accept_ssh:: self.accept_all_from_external {
        port::: 22,
      },
      accept_http:: self.accept_all_from_external {
        port::: 80,
      },
      accept_https:: self.accept_all_from_external {
        port::: 80,
      },

      master_all_internal: self.accept_all_from_internal { security_group: '${scaleway_security_group.master.id}' },
      master_ping: self.accept_ping_from_external { security_group: '${scaleway_security_group.master.id}' },
      master_ssh: self.accept_ssh { security_group: '${scaleway_security_group.master.id}' },
      master_http: self.accept_http { security_group: '${scaleway_security_group.master.id}' },
      master_https: self.accept_https { security_group: '${scaleway_security_group.master.id}' },
      master_api: self.accept_https { security_group: '${scaleway_security_group.master.id}', port::: 6443 },

      worker_all_internal: self.accept_all_from_internal { security_group: '${scaleway_security_group.worker.id}' },
      worker_ping: self.accept_ping_from_external { security_group: '${scaleway_security_group.worker.id}' },
      worker_ssh: self.accept_ssh { security_group: '${scaleway_security_group.worker.id}' },
      worker_http: self.accept_http { security_group: '${scaleway_security_group.worker.id}' },
      worker_https: self.accept_https { security_group: '${scaleway_security_group.worker.id}' },
    },

    scaleway_user_data: {
      master_role: scw.ScalewayUserData {
        server: '${scaleway_server.master_01.id}',
        key: 'role',
        value: 'master',
      },
    },
  },
}
