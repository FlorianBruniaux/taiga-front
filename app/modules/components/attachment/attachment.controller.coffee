class AttachmentController
    @.$inject = [
        'tgAttachmentsService',
        '$translate'
    ]

    editable: false

    constructor: (@attachmentsService, @translate) ->
        @.form = {}
        @.form.description = @.attachment.get('description')
        @.form.is_deprecated = @.attachment.get('is_deprecated')

        @.title = @translate.instant("ATTACHMENT.TITLE", {
                            fileName: @.attachment.get('name'),
                            date: moment(@.attachment.get('created_date')).format(@translate.instant("ATTACHMENT.DATE"))
                        })

    editMode: (mode) ->
        @.editable = mode

    delete: () ->
        @.onDelete({attachment: @.attachment}) if @.onDelete

    save: () ->
        @.editable = false

        @.attachment = @.attachment.set('description', @.form.description)
        @.attachment = @.attachment.set('is_deprecated', @.form.is_deprecated)

        @.onUpdate({attachment: @.attachment}) if @.onUpdate

angular.module('taigaComponents').controller('Attachment', AttachmentController)
