
use strict;
use warnings;

use 5.006;

use ExtUtils::MakeMaker 6.30;



my %WriteMakefileArgs = (
  "ABSTRACT" => "Make your attribute(s) tolerant to undef initialization",
  "AUTHOR" => "Cory G Watson <gphat at cpan.org>",
  "BUILD_REQUIRES" => {
    "File::Find" => 0,
    "File::Temp" => 0,
    "Test::CheckDeps" => "0.002",
    "Test::Fatal" => 0,
    "Test::Moose" => 0,
    "Test::More" => "0.88",
    "Test::NoWarnings" => "0.94"
  },
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => "6.30"
  },
  "DISTNAME" => "MooseX-UndefTolerant",
  "EXE_FILES" => [],
  "LICENSE" => "perl",
  "NAME" => "MooseX::UndefTolerant",
  "PREREQ_PM" => {
    "Moose" => "0.89",
    "Moose::Exporter" => 0,
    "Moose::Role" => 0,
    "strict" => 0,
    "warnings" => 0
  },
  "VERSION" => "0.18",
  "test" => {
    "TESTS" => "t/*.t"
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
  my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
  my $pp = $WriteMakefileArgs{PREREQ_PM};
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod};
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



