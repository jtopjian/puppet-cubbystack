cubbystack
==========

Introduction
------------
cubbystack is a set of alternative Puppet manifests to the official Puppet OpenStack modules. It differs from the official Puppet OpenStack modules in that it places a lot more responsibility on the end-user with regard to configuring their OpenStack installation. The tradeoff of this is a set of manifests that are much more simple, concise, and offer a large amount of flexibility when designing your OpenStack environment.

*Important*: cubbystack is in no way trying to compete with the official Puppet OpenStack modules. In fact, it requires them at this time. cubbystack is simply an alternative way of using Puppet to configure OpenStack.

Why?
----
I created these manifests because I see a continuing trend in the official Puppet OpenStack modules of placing emphasis and conditional logic on individual parameters. If the parameters were removed from the modules, all that would be left is the management of some packages, files, and services -- and that's exactly what cubbystack contains.

These manifests take the stance that the Puppet administrator understands OpenStack and does not need assistance with building a configuration file. By providing the ability to supply a set of configuration options, these manifests can be used to create many different OpenStack installations. In addition, as long as the user stays up to date with valid configuration options, these manifests can more easily support multiple releases of OpenStack (pending compatibility of the Puppet OpenStack types and providers).

Further, these manifests are made for cloud operators who have unique environments and require control toward what gets installed and how. For example, the official Puppet OpenStack Horizon module goes through a lot of work to help you configure Apache to host Horizon. cubbystack's Horizon manifest doesn't and assumes that you will do this configuration yourself. cubbystack only configures OpenStack -- nothing more, nothing less.

Requirements
------------
At this time, cubbystack uses the Puppet OpenStack types and providers, so you must have the official Puppet OpenStack modules installed.

Additionally, you need to be using Puppet 3.2 or higher in order to take advantage of the iteration functionality.

Hiera is recommended, but not a hard requirement.

Usage
-----
cubbystack has a set of manifests for almost all OpenStack components (no Quantum at this time). These can be found in the `manifests` directory. Please read and review these manifests -- they should be self-explanatory and easy to understand.

All components take a `$settings` parameter. This is a hash of `key => value` settings that ultimately turn into the configuration options for the various OpenStack configuration files. Please see the `manifests/examples/settings` directory for samples of hashes.

You can use Hiera or basic Puppet to build your hash -- just as long as what is passed as a parameter is a valid hash.

Each component also has the option to purge all existing configuration options in its configuration file. This allows you to ensure that the only options in the OpenStack configuration files are those that you specify in your `$settings` hash. If this is too strict for you, you can choose to not purge.

Please see the `manifests/examples/roles` directory for sample manifests including examples for supporting services.

Notes
-----

* As mentioned, there is no Quantum support at this time.
* Swift support is early. I'm not 100% happy with it.
* The Horizon manifest does not accept a `$settings` parameter like the other components. Unfortunately, there is no easy way to manage Horizon's `local_settings.py` file by way of a Puppet resource. My suggestion is to simply supply a static file or template.
* As you can see from the manifests, special care has been taken to ensure OpenStack can be installed in a predictable order.
* The name "cubbystack" comes from my son's nickname *Cubby*. I've been surrounded by pictures of bears and cubs lately, so all of my projects are getting prefixed with "cubby".
