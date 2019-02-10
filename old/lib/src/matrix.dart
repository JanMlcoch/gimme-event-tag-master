part of tag_master_common;

class Matrix{
  String user="Anonym";
  List<List<double>> matrix;
  
  Matrix(Tags tags){
    int length = tags.list.length;
      matrix = new List(length);
      for(int i = 0;i < length;i++){
        List inner = [];
        matrix[i] = inner;
        for(int j = 0;j < length;j++){
          inner.add(null);
        }
      }
  }
  double getValue(int i,int j){
    if(i<0&&i>matrix.length){return 0.0;}
    if(j<0&&j>matrix[0].length){return 0.0;}
    return matrix[i][j];
  }
  List<List<double>> submatrix(Block block){
    List<List<double>> sub=new List<List<double>>(block.xlen);
    for(int i=0;i<block.xlen;i++){
      List<double> line=new List<double>(block.ylen);
      for(int j=0;j<block.ylen;i++){
        line[j]=matrix[block.xbegin+i][block.ybegin+j];
      }
      sub[i]=line;
    }
    return sub;
  }
  void pasteSubmatrix(List<List<double>> submatrix,Block block){
    for(int i=0;i<block.xlen;i++){
      for(int j=0;j<block.ylen;j++){
        matrix[i+block.xbegin][j+block.ybegin]=submatrix[i][j];
      }
    }
  }
}