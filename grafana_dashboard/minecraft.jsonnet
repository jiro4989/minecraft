local grafana = import 'grafonnet/grafana.libsonnet';
local dashboard = grafana.dashboard;
local graphPanel = grafana.graphPanel;
local singlestat = grafana.singlestat;
local prometheus = grafana.prometheus;

local mcInstance = 'minecraft:9100';

// CPU rate
local cpuRateFmt = 'rate(node_cpu_seconds_total{job="node",mode="%s"}[5m]) * 100';
local exprCpuSystem = cpuRateFmt % "system";
local exprCpuUser = cpuRateFmt % "user";

// Mem used
local mcMemTotal = 'node_memory_MemTotal_bytes{instance="%s",job="node"}' % mcInstance;
local mcMemAvailable = 'node_memory_MemAvailable_bytes{instance="%s",job="node"}' % mcInstance;
local exprMemUsed = '(%s - %s) / %s * 100' % [mcMemTotal, mcMemAvailable, mcMemTotal];

local resourcePanel(title, expr) =
  graphPanel.new(
    title=title,
    datasource='Prometheus',
  ).addTarget(
    prometheus.target(
      expr=expr,
    )
  );

local exprSystemRuntime = 'time() - node_boot_time_seconds{instance="%s"}' % mcInstance;
local singlestatPanel(title, expr) =
  singlestat.new(
    title=title,
    datasource='Prometheus',
  ).addTarget(
    prometheus.target(
      expr=expr,
    )
  );

local gridPos = {
  x: 0,
  y: 0,
  w: 12,
  h: 8,
};

local w2 = 12;
local h = 8;

dashboard.new(
  'minecraft resources',
  refresh='10s',
)
.addPanel(singlestatPanel('System runtime', exprSystemRuntime), {x:0, y:0, w:4, h:4})
.addPanel(resourcePanel('system used CPU rate', exprCpuSystem), {x:0, y:0, w:w2, h:h})
.addPanel(resourcePanel('user used CPU rate', exprCpuUser), {x:w2, y:0, w:w2, h:h})
.addPanel(resourcePanel('Used memory rate', exprMemUsed), {x:0, y:0, w:w2, h:h})
