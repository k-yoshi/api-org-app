'use strict'

var ntApp = angular.module('ntApp', []);

ntApp.controller('noteCtrl', function($scope, $http, $compile){
    /*
    $http.get('/api/note/list').success(function(data){
        $scope.notes = data;
    });
    */
    _refreshNote();

    $scope.openNoteEditorNew = function() {
        $scope.noteId = 0;
        $scope.noteTitle = "";
        $scope.noteText = "";
        $('#modal-note-editor').modal();
    };

    $scope.openNoteEditor = function(note){
        $http.get('/api/note/'+note.id).success(function(data){
            $scope.noteId = data.id;
            $scope.noteTitle = data.title;
            $scope.noteText = data.text;
            $('#modal-note-editor').modal();
        });
    };

    $scope.addNote = function() {
        var postData = {
            id: $scope.noteId,
            title: $scope.noteTitle,
            text: $scope.noteText,
        };
        if($scope.noteId == 0) {
            // insert
            $.ajax({
                type: 'POST',
                url: '/api/note/add',
                data: postData,
                success: function() {
                    _refreshNote();
                    $('#modal-note-editor').modal('hide');
                },
                error: function() {
                    window.alert("Error updating note");
                },
            });
        
        } else {
            // update
            $.ajax({
                type: 'POST',
                url: '/api/note/' + $scope.noteId + '/update',
                data: postData,
                success: function() {
                    _refreshNote();
                    $('#modal-note-editor').modal('hide');
                },
                error: function() {
                    window.alert("Error updating note");
                },
            });
        }
    };

    $scope.confirmDeleteNote = function(note) {
        $scope.note = note;
        $scope.confirmText = "Are you sure to delete this note?";
        $scope.operationType = 'delete';
        $('#modal-confirm').modal();
    };

    $scope.confirmConvertNote = function(note) {
        $scope.note = note;
        $scope.confirmText = "Are you sure to convert this to TODO?";
        $scope.operationType = 'convert';
        $('#modal-confirm').modal();
    };

    $scope.submitConfirm = function() {
        if($scope.operationType == 'delete') {
            $.ajax({
                type: 'POST',
                url: '/api/note/' + $scope.note.id + '/delete',
                success: function() {
                    _refreshNote();
                    $('#modal-confirm').modal('hide');
                },
                error: function() {
                    window.alert("Error deleting note");
                },
            });
        } else if($scope.operationType == 'convert') {
            $.ajax({
                type: 'POST',
                url: '/api/note/' + $scope.note.id + '/convert',
                success: function() {
                    _refreshNote();
                    $('#modal-confirm').modal('hide');
                },
                error: function() {
                    window.alert("Error converting note");
                },
            });

        }
    };

    function _refreshNote() {
        $http.get('/api/note/list').success(function(data){
            $scope.notes = data;
        });
    }
});

ntApp.controller('todoCtrl', function($scope, $http){
    _refreshTodo();

    $scope.openTodoEditorNew = function() {
        $scope.todoId = 0;
        $scope.todoTitle = "";
        $scope.todoText = "";
        $scope.todoDone = 0;
        $('#modal-todo-editor').modal();
    }

    $scope.openTodoEditor = function(todo){
        $scope.todoId = todo.id;
        $scope.todoTitle = todo.title;
        $scope.todoText = todo.text;
        $scope.todoDone = todo.done;
        $('#modal-todo-editor').modal();
    };

    $scope.addTodo = function() {
        var postData = {
            id: $scope.todoId,
            title: $scope.todoTitle,
            done: $scope.todoDone,
        };
        if($scope.todoId == 0) {
            // insert
            $.ajax({
                type: 'POST',
                url: '/api/todo/add',
                data: postData,
                success: function() {
                    _refreshTodo();
                    $('#modal-todo-editor').modal('hide');
                },
                error: function() {
                    window.alert("Error updating todo");
                },
            });
        
        } else {
            // update
            $.ajax({
                type: 'POST',
                url: '/api/todo/' + $scope.todoId + '/update',
                data: postData,
                success: function() {
                    _refreshTodo();
                    $('#modal-todo-editor').modal('hide');
                },
                error: function() {
                    window.alert("Error updating TODO");
                },
            });
        }
    };

    $scope.confirmDeleteTodo = function(todo) {
        $scope.todo = todo;
        $scope.confirmText = "Are you sure to delete this TODO?";
        $scope.operationType = 'delete';
        $('#modal-confirm').modal();
    };

    $scope.confirmConvertTodo = function(todo) {
        $scope.todo = todo;
        $scope.confirmText = "Are you sure to convert this to note?";
        $scope.operationType = 'convert';
        $('#modal-confirm').modal();
    };

    $scope.changeTodoDone = function($event, todo) {
        var target = $($event.currentTarget);
        var done = target.prop('checked') ? 1 : 0;
        var postData = {
            id: todo.id,
            title: todo.title,
            done: done,
            noTimestamp: 1,
        };
        $.ajax({
            type: 'POST',
            url: '/api/todo/' + todo.id + '/update',
            data: postData,
            success: function() {
                //_refreshTodo();
            },
            error: function() {
                window.alert("Error updating TODO");
                // change back checkbox when error occurs
                var newVal = target.prop("checked") ? false : true;
                target.prop("checked", newVal);
            },
        });
    }

    $scope.submitConfirm = function() {
        if($scope.operationType == 'delete') {
            $.ajax({
                type: 'POST',
                url: '/api/todo/' + $scope.todo.id + '/delete',
                success: function() {
                    _refreshTodo();
                    $('#modal-confirm').modal('hide');
                },
                error: function() {
                    window.alert("Error deleting TODO");
                },
            });
        } else if($scope.operationType == 'convert') {
            $.ajax({
                type: 'POST',
                url: '/api/todo/' + $scope.todo.id + '/convert',
                success: function() {
                    _refreshTodo();
                    $('#modal-confirm').modal('hide');
                },
                error: function() {
                    window.alert("Error converting TODO");
                },
            });
        }
    };
    function _refreshTodo() {
        $http.get('/api/todo/list').success(function(data){
            $scope.todos = data;
        });
    }
});

