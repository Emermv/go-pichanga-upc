export default {
  serialize(data){
    var form=new FormData();
    for(var key in data){
      form.append(key,data[key]);
    }
    return form;

  }
}
