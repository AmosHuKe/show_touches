{{flutter_js}}
{{flutter_build_config}}

_flutter.loader.load({
  config: {
    assetBase: '/show_touches/',
    canvasKitVariant: 'full',
    canvasKitBaseUrl: '/show_touches/canvaskit/'
  },
  serviceWorkerSettings: {
    serviceWorkerVersion: {{flutter_service_worker_version}},
  },
  onEntrypointLoaded: async function (engineInitializer) {
    const appRunner = await engineInitializer.initializeEngine();
    await appRunner.runApp();
  },
});