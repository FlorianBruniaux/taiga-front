class AttachmentsController
    @.$inject = [
        "tgAttachmentsService"
    ]

    constructor: (@attachmentsService) ->
        @.deprecatedsVisible = false
        @.maxFileSize = @attachmentsService.maxFileSize
        @.maxFileSizeFormated = @attachmentsService.maxFileSizeFormated

    generate: () ->
        @.deprecatedsCount = @.attachments.count (it) -> it.get('is_deprecated')

        # if @.deprecatedsVisible
        #     @.attachments = @.attachments
        # else
        #     @.attachments = @.attachmentsAll.filterNot (it) -> it.get('is_deprecated')

    toggleDeprecatedsVisible: () ->
        @.deprecatedsVisible = !@.deprecatedsVisible
        @.generate()

    addAttachment: (file) ->
        attachment = Immutable.fromJS({
            file: file,
            name: file.name,
            size: file.size
        })

        if @attachmentsService.validate(file)
            @.attachments = @.attachments.push(attachment)

        if @.onAdd
            @.onAdd({attachment: attachment})

    addAttachments: (files) ->
        _.forEach files, @.addAttachment.bind(this)

    deleteAttachment: (toDeleteAttachment) ->
        @.attachments = @.attachments.filter (attachment) -> attachment != toDeleteAttachment

        if @.onDelete
            @.onDelete({attachment: toDeleteAttachment})

    reorderAttachment: (attachment, newIndex) ->
        oldIndex = @.attachments.findIndex (it) -> it == attachment
        return if oldIndex == newIndex

        @.attachments = @.attachments.remove(oldIndex)
        @.attachments = @.attachments.splice(newIndex, 0, attachment)

        @.attachments = @.attachments.map (x, i) -> x.set('order', i + 1)

    updateAttachment: (toUpdateAttachment) ->
        index = @.attachments.findIndex (attachment) ->
            return attachment.get('id') == toUpdateAttachment.get('id')

        @.attachments = @.attachments.update index, () -> toUpdateAttachment

angular.module("taigaComponents").controller("Attachments", AttachmentsController)
