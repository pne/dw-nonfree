# Hooks for the entry form
#
# Authors:
#     Afuna <coder.dw@afunamatata.com>
#
# Copyright (c) 2009 by Dreamwidth Studios, LLC.
#
# This program is NOT free software or open-source; you can use it as an
# example of how to implement your own site-specific extensions to the
# Dreamwidth Studios open-source code, but you cannot use it on your site
# or redistribute it, with or without modifications.
#

package DW::Hooks::EntryForm;

use strict;
use warnings;
use LJ::Hooks;

LJ::Hooks::register_hook( 'entryforminfo', sub {
    my ( $journal, $remote ) = @_;

    my $make_list = sub {
        my $ret = '';
        foreach my $link_info ( @_ ) {
            $ret .= "<li><a href='$link_info->[0]'>$link_info->[1]</a></li>"
                if $link_info->[2];
        }
        return "<ul>$ret</ul>";
    };

    my $usejournal = $journal ? "?usejournal=$journal" : "";
    my $ju = $journal ? LJ::load_user( $journal ) : undef;

    my $can_make_poll = 0;
    $can_make_poll = $remote->can_create_polls if $remote;
    $can_make_poll ||= $ju->can_create_polls if $ju;

    return $make_list->(
        # URL, link text, whether to show or not
        [ "/poll/create$usejournal", LJ::Lang::ml( 'entryform.pollcreator' ), $can_make_poll ],
        [ "/support/faqbrowse?faqid=103", LJ::Lang::ml( 'entryform.htmlfaq' ), 1 ],
        [ "/support/faqbrowse?faqid=155", LJ::Lang::ml( 'entryform.htmlfaq.detail' ), 1 ],
        [ "/support/faqbrowse?faqid=82", LJ::Lang::ml( 'entryform.htmlfaq.site' ), 1 ],
    );
    
} );

1;

