# Load modules and classes
lookup('classes', {merge => unique}).include

class { 'python':
  provider => 'pip',
    dev    => 'present',
}
