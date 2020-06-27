function mpc = int_case39
%INT_CASE39 IEEE 39 bus case whith load profile/power-flow set to IEEE
% Small-signal stability benchmark systems.

%% MATPOWER Case Format : Version 2
mpc.version = '2';

%%-----  Power Flow Data  -----%%
%% system MVA base
mpc.baseMVA = 100;

%% bus data
%	bus_i	type	Pd	Qd	Gs	Bs	area	Vm	Va	baseKV	zone	Vmax	Vmin
mpc.bus = [
	1	1	0	0	0	0	1	1.039	-13.539	345	0	1.06	0.94;
	2	1	0	0	0	0	1	1.048	-9.786	345	0	1.06	0.94;
	3	1	322	2.4	0	0	1	1.031	-12.278	345	0	1.06	0.94;
	4	1	500	184	0	0	1	1.004	-12.628	345	0	1.06	0.94;
	5	1	0	0	0	0	1	1.006	-11.19	345	0	1.06	0.94;
	6	1	0	0	0	0	1	1.008	-10.411	345	0	1.06	0.94;
	7	1	233.8	84	0	0	1	0.9984	-12.754	345	0	1.06	0.94;
	8	1	522	176.6	0	0	1	0.9979	-13.338	345	0	1.06	0.94;
	9	1	0	0	0	0	1	1.038	-14.181	345	0	1.06	0.94;
	10	1	0	0	0	0	1	1.018	-8.17	345	0	1.06	0.94;
	11	1	0	0	0	0	1	1.013	-8.938	345	0	1.06	0.94;
	12	1	7.5	88	0	0	1	1.001	-9.001	345	0	1.06	0.94;
	13	1	0	0	0	0	1	1.015	-8.932	345	0	1.06	0.94;
	14	1	0	0	0	0	1	1.012	-10.714	345	0	1.06	0.94;
	15	1	320	153	0	0	1	1.016	-11.345	345	0	1.06	0.94;
	16	1	329	32.3	0	0	1	1.033	-10.032	345	0	1.06	0.94;
	17	1	0	0	0	0	1	1.034	-11.115	345	0	1.06	0.94;
	18	1	158	30	0	0	1	1.032	-11.986	345	0	1.06	0.94;
	19	1	0	0	0	0	1	1.05	-5.41	345	0	1.06	0.94;
	20	1	628	103	0	0	1	0.991	-6.824	345	0	1.06	0.94;
	21	1	274	115	0	0	1	1.032	-7.626	345	0	1.06	0.94;
	22	1	0	0	0	0	1	1.05	-3.183	345	0	1.06	0.94;
	23	1	274	84.6	0	0	1	1.045	-3.381	345	0	1.06	0.94;
	24	1	308.6	-92.2	0	0	1	1.038	-9.912	345	0	1.06	0.94;
	25	1	224	47.2	0	0	1	1.058	-8.371	345	0	1.06	0.94;
	26	1	139	17	0	0	1	1.053	-9.437	345	0	1.06	0.94;
	27	1	281	75.5	0	0	1	1.038	-11.362	345	0	1.06	0.94;
	28	1	206	27.6	0	0	1	1.05	-5.93	345	0	1.06	0.94;
	29	1	283.5	26.9	0	0	1	1.05	-3.17	345	0	1.06	0.94;
	30	2	0	0	0	0	1	1.05	-7.368	345	0	1.06	0.94;
	31	3	9.2	4.6	0	0	1	0.982	0	345	0	1.06	0.94;
	32	2	0	0	0	0	1	0.9841	-0.188	345	0	1.06	0.94;
	33	2	0	0	0	0	1	0.9972	-0.193	345	0	1.06	0.94;
	34	2	0	0	0	0	1	1.012	-1.631	345	0	1.06	0.94;
	35	2	0	0	0	0	1	1.049	1.777	345	0	1.06	0.94;
	36	2	0	0	0	0	1	1.064	4.468	345	0	1.06	0.94;
	37	2	0	0	0	0	1	1.028	-1.583	345	0	1.06	0.94;
	38	2	0	0	0	0	1	1.026	3.893	345	0	1.06	0.94;
	39	2	1104	250	0	0	1	1.03	-14.536	345	0	1.06	0.94;
];

%% generator data
%	bus	Pg	Qg	Qmax	Qmin	Vg	mBase	status	Pmax	Pmin	Pc1	Pc2	Qc1min	Qc1max	Qc2min	Qc2max	ramp_agc	ramp_10	ramp_30	ramp_q	apf
mpc.gen = [
	30	250	    0	400	140		1.05	100	1	350		0	0	0	0	0	0	0	0	0	0	0	0;
	31	677.9	0	300	-100	0.982	100	1	1115.96	0	0	0	0	0	0	0	0	0	0	0	0;
	32	650	    0	300	150		0.9841	100	1	750		0	0	0	0	0	0	0	0	0	0	0	0;
	33	632		0	250	0		0.9972	100	1	732		0	0	0	0	0	0	0	0	0	0	0	0;
	34	508		0	167	0		1.012	100	1	608		0	0	0	0	0	0	0	0	0	0	0	0;
	35	650		0	300	-100	1.049	100	1	750		0	0	0	0	0	0	0	0	0	0	0	0;
	36	560		0	240	0		1.064	100	1	660		0	0	0	0	0	0	0	0	0	0	0	0;
	37	540		0	250	0		1.028	100	1	640		0	0	0	0	0	0	0	0	0	0	0	0;
	38	830		0	300	-150	1.026	100	1	930		0	0	0	0	0	0	0	0	0	0	0	0;
	39	1000	0	300	-100	1.03	100	1	1100	0	0	0	0	0	0	0	0	0	0	0	0;
];

%% branch data
%	fbus	tbus	r	x	b	rateA	rateB	rateC	ratio	angle	status	angmin	angmax
mpc.branch = [
	1	2	0.0035	0.0411	0.6987	600	0	0	0	0	1	-360	360;
	1	39	0.001	0.025	0.75	1000	0	0	0	0	1	-360	360;
	2	3	0.0013	0.0151	0.2572	500	0	0	0	0	1	-360	360;
	2	25	0.007	0.0086	0.146	500	0	0	0	0	1	-360	360;
	2	30	0	0.0181	0	900	0	0	1.025	0	1	-360	360;
	3	4	0.0013	0.0213	0.2214	500	0	0	0	0	1	-360	360;
	3	18	0.0011	0.0133	0.2138	500	0	0	0	0	1	-360	360;
	4	5	0.0008	0.0128	0.1342	600	0	0	0	0	1	-360	360;
	4	14	0.0008	0.0129	0.1382	500	0	0	0	0	1	-360	360;
	5	6	0.0002	0.0026	0.0434	1200	0	0	0	0	1	-360	360;
	5	8	0.0008	0.0112	0.1476	900	0	0	0	0	1	-360	360;
	6	7	0.0006	0.0092	0.113	900	0	0	0	0	1	-360	360;
	6	11	0.0007	0.0082	0.1389	480	0	0	0	0	1	-360	360;
	6	31	0	0.025	0	1800	0	0	1.07	0	1	-360	360;
	7	8	0.0004	0.0046	0.078	900	0	0	0	0	1	-360	360;
	8	9	0.0023	0.0363	0.3804	900	0	0	0	0	1	-360	360;
	9	39	0.001	0.025	1.2	900	0	0	0	0	1	-360	360;
	10	11	0.0004	0.0043	0.0729	600	0	0	0	0	1	-360	360;
	10	13	0.0004	0.0043	0.0729	600	0	0	0	0	1	-360	360;
	10	32	0	0.02	0	900	0	0	1.07	0	1	-360	360;
	12	11	0.0016	0.0435	0	500	0	0	1.006	0	1	-360	360;
	12	13	0.0016	0.0435	0	500	0	0	1.006	0	1	-360	360;
	13	14	0.0009	0.0101	0.1723	600	0	0	0	0	1	-360	360;
	14	15	0.0018	0.0217	0.366	600	0	0	0	0	1	-360	360;
	15	16	0.0009	0.0094	0.171	600	0	0	0	0	1	-360	360;
	16	17	0.0007	0.0089	0.1342	600	0	0	0	0	1	-360	360;
	16	19	0.0016	0.0195	0.304	600	0	0	0	0	1	-360	360;
	16	21	0.0008	0.0135	0.2548	600	0	0	0	0	1	-360	360;
	16	24	0.0003	0.0059	0.068	600	0	0	0	0	1	-360	360;
	17	18	0.0007	0.0082	0.1319	600	0	0	0	0	1	-360	360;
	17	27	0.0013	0.0173	0.3216	600	0	0	0	0	1	-360	360;
	19	20	0.0007	0.0138	0	900	0	0	1.06	0	1	-360	360;
	19	33	0.0007	0.0142	0	900	0	0	1.07	0	1	-360	360;
	20	34	0.0009	0.018	0	900	0	0	1.009	0	1	-360	360;
	21	22	0.0008	0.014	0.2565	900	0	0	0	0	1	-360	360;
	22	23	0.0006	0.0096	0.1846	600	0	0	0	0	1	-360	360;
	22	35	0	0.0143	0	900	0	0	1.025	0	1	-360	360;
	23	24	0.0022	0.035	0.361	600	0	0	0	0	1	-360	360;
	23	36	0.0005	0.0272	0	900	0	0	1	0	1	-360	360;
	25	26	0.0032	0.0323	0.531	600	0	0	0	0	1	-360	360;
	25	37	0.0006	0.0232	0	900	0	0	1.025	0	1	-360	360;
	26	27	0.0014	0.0147	0.2396	600	0	0	0	0	1	-360	360;
	26	28	0.0043	0.0474	0.7802	600	0	0	0	0	1	-360	360;
	26	29	0.0057	0.0625	1.029	600	0	0	0	0	1	-360	360;
	28	29	0.0014	0.0151	0.249	600	0	0	0	0	1	-360	360;
	29	38	0.0008	0.0156	0	1200	0	0	1.025	0	1	-360	360;
];

%%-----  OPF Data  -----%%
%% generator cost data
%	1	startup	shutdown	n	x1	y1	...	xn	yn
%	2	startup	shutdown	n	c(n-1)	...	c0
mpc.gencost = [
	2	0	0	3	0.04	20	0;
	2	0	0	3	0.0147514383	20	0;
	2	0	0	3	0.0153846154	20	0;
	2	0	0	3	0.0158227848	20	0;
	2	0	0	3	0.0196850394	20	0;
	2	0	0	3	0.0153846154	20	0;
	2	0	0	3	0.0178571429	20	0;
	2	0	0	3	0.0185185185	20	0;
	2	0	0	3	0.0120481928	20	0;
	2	0	0	3	0.01	20	0;
];

%% bus names
mpc.bus_name = {
	'Bus 1';
	'Bus 2';
	'Bus 3';
	'Bus 4';
	'Bus 5';
	'Bus 6';
	'Bus 7';
	'Bus 8';
	'Bus 9';
	'Bus 10';
	'Bus 11';
	'Bus 12';
	'Bus 13';
	'Bus 14';
	'Bus 15';
	'Bus 16';
	'Bus 17';
	'Bus 18';
	'Bus 19';
	'Bus 20';
	'Bus 21';
	'Bus 22';
	'Bus 23';
	'Bus 24';
	'Bus 25';
	'Bus 26';
	'Bus 27';
	'Bus 28';
	'Bus 29';
	'Bus 30';
	'Bus 31';
	'Bus 32';
	'Bus 33';
	'Bus 34';
	'Bus 35';
	'Bus 36';
	'Bus 37';
	'Bus 38';
	'Bus 39';
};
