use strict;
use warnings;
use Test::More;


use NoteAndTodo;
use NoteAndTodo::Web;
use NoteAndTodo::Web::View;
use NoteAndTodo::Web::ViewFunctions;

use NoteAndTodo::DB::Schema;
use NoteAndTodo::Web::Dispatcher;


pass "All modules can load.";

done_testing;
