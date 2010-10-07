package MT::Plugin::OMV::IsInArray;

use strict;
use MT 4;

use vars qw( $MYNAME $VERSION );
($MYNAME) = __PACKAGE__ =~ /.+::(.+)/;
$VERSION = '0.01';

use base qw( MT::Plugin );
my $plugin = __PACKAGE__->new({
    id => $MYNAME,
    key => $MYNAME,
    name => $MYNAME,
    version => $VERSION,
    author_name => 'Open MagicVox.net',
    author_link => 'http://www.magicvox.net/',
    doc_link => 'http://www.magicvox.net/archive/2010/10072217/',
    description => <<HTMLHEREDOC,
Search the specified value in the array/hash
HTMLHEREDOC
    registry => {
        tags => {
            block => {
                "IsInArray?" => \&_tag_IsInArray,
                "IsInHash?" => \&_tag_IsInArray,
            },
        },
    },
});
MT->add_plugin( $plugin );

sub _tag_IsInArray {
    my ($ctx, $args) = @_;

    defined (my $name = $args->{name} || $args->{var})
        or return $ctx->error ('name must be specified in arguments.');
    defined (my $value = $args->{value})
        or return $ctx->error ('value must be specified in arguments.');

    my $var = $ctx->var($name);
    if (ref($var) eq 'ARRAY') {
        foreach (0..@$var) {
            if ($var->[$_] == $value) {
                $ctx->var ('__index__', $_);
                return 1;
            }
        }
    }
    elsif (ref($var) eq 'HASH') {
        foreach (keys %$var) {
            if ($var->{$_} == $value) {
                $ctx->var ('__key__', $_);
                return 1;
            }
        }
    }
    0;
}

1;