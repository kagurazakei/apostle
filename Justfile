root := justfile_dir()

# to use "pure" mode just override IMPURE=false
switch host=`hostname` *flags:
   nh os switch --file {{root}}/default.nix nC.{{host}} {{flags}} --use-substitutes

test host=`hostname` *flags:
   nh os test --file {{root}}/default.nix nC.{{host}} {{flags}} --use-substitutes

boot host=`hostname` *flags:
   nh os boot --file {{root}}/default.nix nC.{{host}} {{flags}} --use-substitutes

build host=`hostname` *flags:
   nh os build --file {{root}}/default.nix nC.{{host}} {{flags}} --use-substitutes

deploy-boot target host=`hostname` *flags:
   nh os boot --file {{root}}/default.nix nC.{{host}} --build-host localhost --target-host {{target}} {{flags}} --use-substitutes

deploy-switch target host=`hostname` *flags:
   nh os switch --file {{root}}/default.nix nC.{{host}} --build-host localhost --target-host {{target}} {{flags}} --use-substitutes

clean:
   sudo nix-collect-garbage -d; nh clean all; nix-collect-garbage -d; nix-store --gc

update *flags:
  tack update {{flags}}

tackdate: 
  tack update
