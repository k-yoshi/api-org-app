package NoteAndTodo::DB::Result::Item;

use strict;
use warnings;
use utf8;

use base 'DBIx::Class::Core';

use DBIx::Class::Helper::Row::ToJSON;

__PACKAGE__->table('item');

__PACKAGE__->add_columns(
    id => {
        data_type       => 'INTEGER',
        is_nullable     => 0,
        is_auto_increment   => 1,
    },
    type => {
        data_type       => 'TINYINT',
        is_nullable     => 0,
    },
    title => {
        data_type       => 'VARCHAR',
        is_nullable     => 0,
        size            => 255,
    },
    text => {
        data_type       => 'TEXT',
        is_nullable     => 0,
    },
    done => {
        data_type       => 'TINYINT',
        is_nullable     => 0,
    },
    text => {
        data_type       => 'TEXT',
        is_nullable     => 0,
    },
    done => {
        data_type       => 'TINYINT',
        is_nullable     => 0,
    },
    modified_at => {
        data_type       => 'TEXT',
        is_nullable     => 0,
    }
);

__PACKAGE__->set_primary_key('id');

1;
