var play_ground = {

getBallAttr: function($td) {
        var color = parseFloat($td.children().attr('alt'));
        var col = $td.closest("td").index();
        var row = $td.closest("tr").index();
        return  {ball: {color: color, row: row, col: col}};
},

makeBallsSelected: function(balls){
    play_ground.makeBallsUnselected();
    for (var ball in balls){
        var $td = $('#play_ground tr').eq(balls[ball].row).children().eq(balls[ball].col)
        var img_src = $td.children().attr('src').split('.');
        var new_img_src = img_src[0]+"_s." + img_src[1];
        $td.children().attr('src', new_img_src);
        $td.addClass('selected');
    }
},

makeBallsUnselected: function(){
    var balls = $('#play_ground').find('td.selected');
    if (balls.length  > 0){
          for (var ball = 0; ball < balls.length; ball++){
              $td = $(balls[ball]);
              var new_img_src = $td.children().attr('src').split('_s');
              var img_src = new_img_src[0] + new_img_src[1];
              $td.children().attr('src', img_src);
              $td.removeAttr('class');
          }
    }
}

};

var game = {

selected:[],

alreadySelected: function(td){
    selected = game.selected;
    for (var ball=0; ball < selected.length; ball++){
          if ((selected[ball].col == td.col)&&(selected[ball].row==td.row)){
            return true;
          }
    }
    return false;
},

selectGroup:  function (){
      $('#play_ground').on('mouseenter', 'tr td', function(){
            var td = play_ground.getBallAttr($(this));
            if (game.alreadySelected(td.ball) == false){

                var curr_url = window.location.pathname;
                 $.ajax({
                      contentType: "application/json",
                      dataType: "json",
                      type: "POST",
                      url: curr_url + '/select_group',
                      data:  JSON.stringify(td),
                      success: function(selected){
                          game.selected = selected;
                          play_ground.makeBallsSelected(selected);
                        }
                  });
              }
          });
},

updateGame:  function (){
      $('#play_ground').on('click', 'tr td', function(){
            var td = play_ground.getBallAttr($(this));

            var curr_url = window.location.pathname;
             $.ajax({
                  contentType: "application/json",
                  dataType: "script",
                  type: "POST",
                  url: curr_url + '/update_game',
                  data:  JSON.stringify(td)
              });
      });
}

}


game.selectGroup();
game.updateGame();
