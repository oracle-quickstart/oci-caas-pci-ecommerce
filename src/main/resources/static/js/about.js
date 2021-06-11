document.addEventListener("DOMContentLoaded", () => {
    async function getVersion() {
        try {
            let result = await fetch('/version');
            console.log(result)
            // console.log(result);
            return result.json();
        } catch (e) {
            console.log(e);
        }
    }

    getVersion().then(result => {
        document.getElementById("version").innerHTML = result.version;
    })
})
