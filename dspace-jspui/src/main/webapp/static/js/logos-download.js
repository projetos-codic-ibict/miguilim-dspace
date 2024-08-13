function downloadLogos(logos) {
    const zip = new JSZip();
    const filename = "Logomarcas";
    const logosFolder = zip.folder(filename);
    const logoPromises = [];

    for (let logo of logos) {
        const src = logo.src;
        const filename = logo.src.split("/").pop();
        const logoPromise = fetch(src)
            .then((res) => res.blob())
            .then((blob) => logosFolder.file(filename, blob));

        logoPromises.push(logoPromise);
    }

    Promise.all(logoPromises)
        .then(() => zip.generateAsync({ type: "blob" }))
        .then((blob) => saveAs(blob, `${filename}.zip`));
}

document.addEventListener("DOMContentLoaded", function() {
    document.getElementById("btn-download-all").addEventListener("click", function() {
        const logos = document.getElementsByClassName("logo-image");
        downloadLogos(logos);
    });
})
