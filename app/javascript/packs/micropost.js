$('#micropost_images').bind('change', function () {
  var size_in_megabytes = this.files[0].size / 1024 / 1024;
  if (size_in_megabytes > 5) {
    alert(I18n.t('.large_img_error'));
  }
});
function previewFiles(height) {
  const preview = document.querySelector('#preview');
  const files = document.querySelector('input[type=file]').files;
  function readAndPreview(file) {
    if (/\.(jpe?g|png|gif)$/i.test(file.name)) {
      const reader = new FileReader();
      reader.addEventListener("load", () => {
        const image = new Image();
        image.height = height;
        image.title = file.name;
        image.src = reader.result;
        preview.appendChild(image);
      }, false);
      reader.readAsDataURL(file);
    }
  }
  if (files) {
    Array.prototype.forEach.call(files, readAndPreview);
  }
}
window.previewFiles = previewFiles
