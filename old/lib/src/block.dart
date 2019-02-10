part of tag_master_common;

class BlockMatrix{
  List<List<Block>> _blocks;
  
  Block getBlock(int x,int y){
    return _blocks[x][y];
  }
  int size([bool second=false]){
    if(_blocks==null){return 0;}
    if(second){
      if(_blocks.length==0){return 0;}
      return _blocks[0].length;
    }else{
      return _blocks.length;
    }
  }
  List<List<Map>> toJson(){
    List<List<Map>> json=[];
    for(List<Block> line in _blocks){
      List<Map> jline=[];
      for(Block block in line){
        jline.add(block.toJson());
      }
      json.add(jline);
    }
    return json;
  }
  void fromJson(List<List<Map>> json){
    _blocks=new List<List<Block>>();
    for(List<Map> jline in json){
      List<Block> line=new List<Block>();
      for(Map jblock in jline){
        line.add(new Block()..fromJson(jblock));
      }
      _blocks.add(line);
    }
  }
  
  void createBlocks(Tags tags) {
    int length = tags.list.length;
//  int blockCount1D = length % blockMaxLength != 0 ? ((length - length % blockMaxLength) ~/ blockMaxLength) + 1 : ((length - length % blockMaxLength) ~/ blockMaxLength);
//  int blockLength = (length % blockCount1D != 0) ? ((length - length % blockCount1D) ~/ blockCount1D) + 1 : ((length - length % blockCount1D) ~/ blockCount1D);
    int curXbegin = 0;
    int curYbegin = 0;
    int xlen = BLOCK_LENGTH;
    int ylen;
    int i = 0;
    //List<List<Block>> blocks = new List<List<Block>>();
    while (curXbegin < length) {
      _blocks.add(new List<Block>());
      if (curXbegin + xlen > length) {
        xlen = length - curXbegin;
      }
      ylen=BLOCK_LENGTH;
      curYbegin=0;
      while (curYbegin < length) {
        if (curYbegin + ylen > length) {
          ylen = length - curYbegin;
        }

        _blocks[i].add(new Block()
          ..xbegin = curXbegin
          ..xlen = xlen
          ..ybegin = curYbegin
          ..ylen = ylen);
        curYbegin+=ylen;
      }
      curXbegin+=xlen;
      i++;
    }
  }
}

class Block {
  int xbegin;
  int xlen;
  int ybegin;
  int ylen;
  List<User> editing = [];
  List<User> edited = [];
  Block(){}
  Block.copy(Block block){}
  
  void fromJson(Map<String,dynamic> json){
    xbegin=json["xb"];
    ybegin=json["yb"];
    xlen=json["xl"];
    ylen=json["yl"];
    for(int userid in json["eding"]){
      editing.add(User.getUserById(userid));
    }
    for(int userid in json["eded"]){
      edited.add(User.getUserById(userid));
    }
  }
  Map<String,dynamic> toJson(){
      Map<String,dynamic> json={};
      json["xb"]=xbegin;
      json["yb"]=ybegin;
      json["xl"]=xlen;
      json["yl"]=ylen;
      List<int> eding=[];
      for(User user in editing){
        eding.add(user.id);
      }
      List<int> eded=[];
      for(User user in edited){
        eded.add(user.id);
      }
      json["eding"]=eding;
      json["eded"]=eded;
      return json;
    }
  /*bool isZero(){
    for(int i = xbegin;i < xend + 1;i++){
      var temp = matrix[i];
      for(int j = ybegin;j < yend + 1;j++){
        if(temp[j]!=0){
          return false;
        }
      }
    }
    return true;
  }*/

}

class FullBlock extends Block{
  List<List<double>> _matrix;
  
  static Map<String,dynamic> fullBlockToJson(Block block,Matrix matrix){
    Map<String,dynamic> out=block.toJson();
    out["matrix"] = matrix.submatrix(block);
    return out;
  }
  void fromJson(Map<String,dynamic> json){
    super.fromJson(json);
    _matrix=json["matrix"];
  }
  Map<String,dynamic> toJson(){
    Map<String,dynamic> out=super.toJson();
    out["matrix"]=_matrix;
    return out;
  }
} 
