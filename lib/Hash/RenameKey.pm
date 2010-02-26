package Hash::RenameKey;

use strict;
use warnings;
use base 'Class::Accessor';

our $VERSION = '0.01';

sub rename_key {
    my ($self, $hash, $old, $new) = @_;
    print "Replacing $old with $new\n";
    return unless $hash && $old && $new;

    my $recurse = undef;
    $recurse = sub {
        my $input = shift;
        while ( my ($oldkey, $contents) = each %$input ) {
            print "$oldkey : $contents\n";
            my $newkey = $oldkey;
            $newkey =~ s/$old/$new/g;
            $recurse->($contents) if ref $contents eq 'HASH';
            if ( ref $contents eq "ARRAY" ) {
                for my $r ( @{$contents} ) {
                    $recurse->($r);
                }
            }
            $input->{$newkey} = $contents;
            delete $input->{$oldkey} if $oldkey =~ /$old/;
        }
    };
    $recurse->($hash);
    return 1;
}

1;
=head1 NAME

Hash::RenameKey - Perl extension for recursively renaming keys

=head1 SYNOPSIS

  use Hash::RenameKey;

  my $old = '-';
  my $new = '_';
  &rename_key(\%hash, $old, $new);

=head1 DESCRIPTION

This module provides a single function, rename_key, to recursively rename
keys in a hash by replacing any instances of $old with $new in all keys
in the hash, including contents of hashrefs and hashrefs inside arrayrefs.

=head2 EXPORT

rename_key


=head1 AUTHOR

Jason Clifford, E<lt>jason@ukfsn.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2010 by Jason Clifford

This library is free software; you can redistribute it and/or modify
it under the terms of version 2 or later of the GNU GPL as published 
by the Free Software Foundation.

=cut