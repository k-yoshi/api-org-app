package NoteAndTodo::Web::Dispatcher;
use strict;
use warnings;
use utf8;
use Amon2::Web::Dispatcher::RouterBoom;

base 'NoteAndTodo::Web';

use NoteAndTodo::Web::Client;
any '/' => 'Client#index';
any '/note' => 'Client#note';
any '/todo' => 'Client#todo';

use NoteAndTodo::Web::API;
get '/api/note/list' => 'API#note_list';
post '/api/note/add' => 'API#add_note';
post '/api/note/:id/delete' => 'API#delete_note';
post '/api/note/:id/update' => 'API#update_note';
post '/api/note/:id/convert' => 'API#convert_note_to_todo';
get '/api/note/:id' => 'API#note_detail';

get '/api/todo/list' => 'API#todo_list';
post '/api/todo/add' => 'API#add_todo';
post '/api/todo/:id/delete' => 'API#delete_todo';
post '/api/todo/:id/update' => 'API#update_todo';
post '/api/todo/:id/convert' => 'API#convert_todo_to_note';

1;
