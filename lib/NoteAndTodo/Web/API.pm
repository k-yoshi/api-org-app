package NoteAndTodo::Web::API;
use strict;
use warnings;
use utf8;

use JSON;
use POSIX 'strftime';

my $TYPE_NOTE = 1;
my $TYPE_TODO = 2;

sub note_list {
    my ($self, $c) = @_;

    my $schema = $c->db;
    my @notes = $schema->resultset('Item')->search({type=>$TYPE_NOTE}, {order_by=>{-desc=>'modified_at'}});

    my @notes_arr = _items_to_array(@notes);

    my $json_text = encode_json(\@notes_arr);
    return $c->create_response(200, [], $json_text);
}

sub note_detail {
    my ($self, $c, $args) = @_;
    my $note_id = $args->{id};

    my $note = $c->db->resultset('Item')->find({id=>$note_id});

    my $note_hashref = _item_to_hashref($note);

    my $json_text = encode_json($note_hashref);
    return $c->create_response(200, [], $json_text);
}

sub add_note {
    my ($self, $c) = @_;

    $c->db->resultset('Item')->create({
        type => $TYPE_NOTE,
        title => $c->req->param('title'),
        text => $c->req->param('text'),
        done => 0,
        modified_at => _sqlite_now(),
    });

    return $c->create_response(200, [], '');
}

sub delete_note {
    my ($self, $c, $args) = @_;
    my $note_id = $args->{id};

    $c->db->resultset('Item')->find({id=>$note_id})->delete;

    return $c->create_response(200, [], '');
}

sub update_note {
    my ($self, $c, $args) = @_;
    my $note_id = $args->{id};

    $c->db->resultset('Item')->find({id=>$note_id})->update({
        title => $c->req->param('title'),
        text => $c->req->param('text'),
        modified_at => _sqlite_now(),
    });

    return $c->create_response(200, [], '');
}

sub convert_note_to_todo {
    my ($self, $c, $args) = @_;
    my $note_id = $args->{id};

    $c->db->resultset('Item')->find({id=>$note_id})->update({
        type => $TYPE_TODO,
        modified_at => _sqlite_now(),
    });

    return $c->create_response(200, [], '');
}

sub todo_list {
    my ($self, $c) = @_;

    my @todos = $c->db->resultset('Item')->search({type=>$TYPE_TODO}, {order_by=>{-desc=>'modified_at'}});

    my @todos_arr = _items_to_array(@todos);

    my $json_text = encode_json(\@todos_arr);
    return $c->create_response(200, [], $json_text);
}

sub add_todo {
    my ($self, $c) = @_;

    $c->db->resultset('Item')->create({
        type => $TYPE_TODO,
        title => $c->req->param('title'),
        text => "",
        done => 0,
        modified_at => _sqlite_now(),
    });

    return $c->create_response(200, [], '');
}

sub delete_todo {
    my ($self, $c, $args) = @_;
    my $todo_id = $args->{id};

    $c->db->resultset('Item')->find({id=>$todo_id})->delete;

    return $c->create_response(200, [], '');
}

sub update_todo {
    my ($self, $c, $args) = @_;
    my $todo_id = $args->{id};

    my $update_data = +{
        title => $c->req->param('title'),
        done => $c->req->param('done'),
    };
    print $c->req->param('noTimestamp');
    if(!$c->req->param('noTimestamp')) {
        #modified_at => _sqlite_now(),
        $update_data->{modified_at} = _sqlite_now();
    }

#    $c->db->resultset('Item')->find({id=>$todo_id})->update({
#        title => $c->req->param('title'),
#        done => $c->req->param('done'),
#        modified_at => _sqlite_now(),
#    });
    $c->db->resultset('Item')->find({id=>$todo_id})->update($update_data);

    return $c->create_response(200, [], '');
}

sub convert_todo_to_note {
    my ($self, $c, $args) = @_;
    my $todo_id = $args->{id};

    $c->db->resultset('Item')->find({id=>$todo_id})->update({
        type => $TYPE_NOTE,
        modified_at => _sqlite_now(),
    });

    return $c->create_response(200, [], '');
}

sub _items_to_array {
    my (@items) = @_;

    my @items_arr = map {
        _item_to_hashref($_);
    } @items;

    return @items_arr;
}

sub _item_to_hashref {
    my ($item) = @_;

    my $item_hashref = +{
        id => $item->id,
        type => $item->type,
        title => $item->title,
        text => $item->text,
        done => $item->done,
        modified_at => $item->modified_at,
    };

    return $item_hashref;
}

sub _sqlite_now {
    return strftime "%Y-%m-%d %H:%M:%S", localtime;
}

1;
