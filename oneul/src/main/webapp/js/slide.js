window.addEventListener('DOMContentLoaded', () => {
    const slides = document.querySelector('.slides');
    const images = slides.querySelectorAll('img');
    let current = 0;

    setInterval(() => {
        current = (current + 1) % images.length;
        slides.style.transform = `translateX(-${current * 100}%)`;
    }, 3000);
});
