const toggleFilter = () => {
    const trigger = document.getElementById('filterBtn')
    const filters = document.getElementById('filters');
    trigger.addEventListener('click', (e) => {
        if (filters.classList.contains('d-none')) {
            filters.classList.remove('d-none');
            filters.classList.add('d-block');
        } else {
            filters.classList.remove('d-block');
            filters.classList.add('d-none');
        }
    })
}

export { toggleFilter }
