document.addEventListener('bookmark.blacklight', (event) => {
  if (event.detail.checked || !document.body.classList.contains('blacklight-bookmarks-index')) return
  if (!event.target.matches('form.bookmark-toggle')) return

  const url = new URL(window.location.href)
  const page = Number(url.searchParams.get('page')) || 1

  // Removing the last displayed record can leave the current page out of range.
  if (document.querySelectorAll('#documents .document').length === 1 && page > 1) {
    url.searchParams.set('page', page - 1)
  }

  window.location.replace(url.toString())
})
