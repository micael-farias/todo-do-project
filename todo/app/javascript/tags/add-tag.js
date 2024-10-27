export function addTag(tag, containerId, hiddenFieldId) {
    tag = tag.trim();
    if (tag === '') return;

    var existingTags = $(`#${containerId} .tag-badge`).map(function() {
    return $(this).data('tag').toLowerCase();
    }).get();

    if (existingTags.includes(tag.toLowerCase())) {
    alert('Essa tag já foi adicionada.');
    return;
    }

    var tagBadge = $(`
    <span class="tag-badge" data-tag="${tag}">
        ${tag}
        <span class="remove-tag text-light">&times;</span>
    </span>
    `);

    $(`#${containerId}`).append(tagBadge);

    var currentTags = $(`#${hiddenFieldId}`).val();
    if (currentTags) {
    $(`#${hiddenFieldId}`).val(currentTags + ',' + tag);
    } else {
    $(`#${hiddenFieldId}`).val(tag);
    }
}