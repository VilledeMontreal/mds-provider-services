DROP VIEW IF EXISTS lost_31_days CASCADE;

CREATE VIEW lost_31_days AS

select
    concat(provider_name, '_', vehicle_type) as provider,
    cast(date_trunc('day', start_time_local) as date) as day,
    count(distinct device_id) as lost_devices
from
    lost_devices
where
    date_trunc('day', start_time_local) in (select distinct date_trunc('day', start_time_local) as day from lost_devices order by day desc limit 31) 
    and date_trunc('day', start_time_local) < date_trunc('day', csm_local_timestamp(now() - interval '1 day'))
group by
    provider_name, vehicle_type, date_trunc('day', start_time_local)
order by
    provider, day;