# This class configures the RBAC roles for Kubernetes 1.10.x

class kubernetes::cluster_roles (
  Optional[Boolean] $controller = $kubernetes::controller,
  Optional[Boolean] $worker = $kubernetes::worker,
  String $node_name = $kubernetes::node_name,
  String $container_runtime = $kubernetes::container_runtime,
<<<<<<< HEAD
  Optional[Array] $ignore_preflight_errors = []
) {
  $path = ['/usr/bin','/bin','/sbin','/usr/local/bin']
  $env_controller = ['HOME=/root', 'KUBECONFIG=/etc/kubernetes/admin.conf']
  #Worker nodes do not have admin.conf present
  $env_worker = ['HOME=/root', 'KUBECONFIG=/etc/kubernetes/kubelet.conf']

=======
  Optional[Array] $ignore_preflight_errors = $kubernetes::ignore_preflight_errors,
  Optional[Array] $env = $kubernetes::environment,
) {
>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c
  if $container_runtime == 'cri_containerd' {
    $preflight_errors = flatten(['Service-Docker',$ignore_preflight_errors])
    $cri_socket = '/run/containerd/containerd.sock'
  } else {
    $preflight_errors = $ignore_preflight_errors
    $cri_socket = undef
  }


  if $controller {
    kubernetes::kubeadm_init { $node_name:
<<<<<<< HEAD
      path                    => $path,
      env                     => $env_controller,
      ignore_preflight_errors => $preflight_errors,
=======
      ignore_preflight_errors => $preflight_errors,
      env                     => $env,
>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c
      }
    }

  if $worker {
    kubernetes::kubeadm_join { $node_name:
<<<<<<< HEAD
      path                    => $path,
      env                     => $env_worker,
      cri_socket              => $cri_socket,
      ignore_preflight_errors => $preflight_errors,
=======
      cri_socket              => $cri_socket,
      ignore_preflight_errors => $preflight_errors,
      env                     => $env,
>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c
    }
  }
}
