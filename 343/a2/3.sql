SET search_path TO uber, public;

insert into client values
(100, 'Mason', 'Daisy', 'daisy@kitchen.com');


insert into driver values
(12345, 'Fry', 'Phillip', 'January 1, 1990', 'Planet Earth', 'BGSW 412', false);


insert into available values
(12345, '2016-01-08 04:05', '(1, 2)');


-- Locations are specified as longitude and latitude (in that order), in degrees.
insert into place values
('highclere castle', '(1.361, 51.3267)'),
('dower house', '(-0.4632, 51.3552)'),
('eaton centre', '(79.3803,43.654)'),
('cn tower', '(79.3871,43.6426)'),
('north york civic centre', '(79.4146,43.7673)'),
('pearson international airport', '(79.6306,43.6767)'),
('utsc', '(79.1856,43.7836)');


insert into request values
-- rest
(1, 100, '2015-07-01 08:00', 'cn tower', 'pearson international airport'),
(2, 100, '2015-07-02 08:00', 'cn tower', 'pearson international airport'),
(3, 100, '2015-07-02 14:15', 'cn tower', 'pearson international airport'),
(4, 100, '2015-07-03 08:00', 'cn tower', 'pearson international airport');


insert into dispatch values
(1, 12345, '(1, 4)', '2015-07-01 08:01'),
(2, 12345, '(1, 4)', '2015-07-02 08:01'),
(3, 12345, '(1, 4)', '2015-07-02 14:16'),
(4, 12345, '(1, 4)', '2015-07-03 08:01');



insert into pickup values
(1, '2015-07-01 08:05'),
(2, '2015-07-02 08:05'),
(3, '2015-07-02 14:20'),
(4, '2015-07-03 08:05');


insert into dropoff values
(1, '2015-07-01 22:10'),
(2, '2015-07-02 14:10'),
(3, '2015-07-02 22:25'),
(4, '2015-07-03 22:10');


insert into rates values
(3.2, .55);


insert into billed values
(1, 8.5),
(2, 255.2),
(3, 105.4),
(4, 175.5);


insert into driverrating values
(1, 5);

insert into clientrating values
(1, 4);

