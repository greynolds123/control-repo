node default {
  notify { 'alpha': }
<<<<<<< HEAD

  -> class  { 'java':
    distribution => 'jdk',
    version      => 'latest',
  }

  -> class  { 'activemq':
    webconsole => true,
  }

  -> notify { 'omega': }
=======
  ->
  class  { 'java':
    distribution => 'jdk',
    version      => 'latest',
  }
  ->
  class  { 'activemq':
    webconsole => true,
  }
  ->
  notify { 'omega': }
>>>>>>> c9b52c6393265c3a51bd8b3201b3bfbe07fcc044
}
