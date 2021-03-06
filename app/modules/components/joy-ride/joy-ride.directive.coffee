taiga = @.taiga

JoyRideDirective = ($rootScope, currentUserService, joyRideService, $location) ->
    link = (scope, el, attrs, ctrl) ->
        unsuscribe = null
        intro = introJs()

        #Todo: translate
        intro.setOptions({
            exitOnEsc: false,
            exitOnOverlayClick: false,
            showStepNumbers: false,
            nextLabel: 'Next &rarr;',
            prevLabel: '&larr; Back',
            skipLabel: 'Skip',
            doneLabel: 'Done',
            disableInteraction: true
        })

        intro.oncomplete () ->
            $('html,body').scrollTop(0)

        intro.onexit () ->
            currentUserService.disableJoyRide()

        initJoyrRide = (next, config) ->
            if !config[next.joyride]
                return

            intro.setOption('steps', joyRideService.get(next.joyride))
            intro.start()

        $rootScope.$on '$routeChangeSuccess',  (event, next) ->
            if !next.joyride || !currentUserService.isAuthenticated()
                intro.exit()
                unsuscribe() if unsuscribe
                return


            intro.oncomplete () ->
                currentUserService.disableJoyRide(next.joyride)

            if next.loader
                unsuscribe = $rootScope.$on 'loader:end',  () ->
                    currentUserService.loadJoyRideConfig()
                        .then (config) -> initJoyrRide(next, config)

                    unsuscribe()
            else
                currentUserService.loadJoyRideConfig()
                    .then (config) -> initJoyrRide(next, config)

    return {
        scope: {},
        link: link
    }

JoyRideDirective.$inject = [
    "$rootScope",
    "tgCurrentUserService",
    "tgJoyRideService",
    "$location"
]

angular.module("taigaComponents").directive("tgJoyRide", JoyRideDirective)
