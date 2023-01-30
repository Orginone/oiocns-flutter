enum BucketOperates {
  list("List"),
  create("Create"),
  rename("Rename"),
  move("Move"),
  copy("Copy"),
  delete("Delete"),
  upload("Upload"),
  abortUpload("AbortUpload");

  final String keyWord;

  const BucketOperates(this.keyWord);
}
