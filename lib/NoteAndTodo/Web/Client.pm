package NoteAndTodo::Web::Client;
use strict;
use warnings;
use utf8;

#sub index {
#    my ($self, $c) = @_;
#
#    my $tv = +{
#        active => 'home',
#    };
#
#    return $c->render("index.tx", $tv);
#}

sub index {
    my ($self, $c) = @_;
    return $c->redirect('/note');
}

sub note {
    my ($self, $c) = @_;

    my $tv = +{
        active => 'note',
    };

    return $c->render("note.tx", $tv);
}

sub todo {
    my ($self, $c) = @_;

    my $tv = +{
        active => 'todo',
    };

    return $c->render("todo.tx", $tv);
}

1;
