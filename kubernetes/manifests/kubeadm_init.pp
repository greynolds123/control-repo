# == kubernetes::kubeadm_init
define kubernetes::kubeadm_init (
  String $node_name                             = $kubernetes::node_name,
  Optional[String] $config                      = $kubernetes::config_file,
  Boolean $dry_run                              = false,
<<<<<<< HEAD
  Optional[Array] $env                          = undef,
  Optional[Array] $path                         = undef,
  Optional[Array] $ignore_preflight_errors      = undef,
=======
  Array $path                                   = $kubernetes::default_path,
  Optional[Array] $env                          = $kubernetes::environment,
  Optional[Array] $ignore_preflight_errors      = $kubernetes::ignore_preflight_errors,
>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c
) {
  $kubeadm_init_flags = kubeadm_init_flags({
    config                  => $config,
    dry_run                 => $dry_run,
    ignore_preflight_errors => $ignore_preflight_errors,
  })

  $exec_init = "kubeadm init ${kubeadm_init_flags}"
  $unless_init = "kubectl get nodes | grep ${node_name}"

  exec { 'kubeadm init':
    command     => $exec_init,
    environment => $env,
    path        => $path,
    logoutput   => true,
    timeout     => 0,
    unless      => $unless_init,
  }

<<<<<<< HEAD
=======
  # This prevents a known race condition https://github.com/kubernetes/kubernetes/issues/66689
  kubernetes::wait_for_default_sa { 'default': }
>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c
}
