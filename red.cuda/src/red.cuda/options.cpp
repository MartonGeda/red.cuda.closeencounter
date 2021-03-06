// includes system
#include <iostream>

// includes project
#include "redutilcu.h"
#include "number_of_bodies.h"
#include "options.h"
#include "pp_disk.h"
#include "int_euler.h"
#include "int_rungekutta2.h"
#include "int_rungekutta4.h"
#include "int_rungekutta5.h"
#include "int_rungekutta8.h"
#include "util.h"
#include "red_constants.h"
#include "red_macro.h"

using namespace redutilcu;

options::options(int argc, const char** argv) :
	has_gas(false),
	param(0x0),
	g_disk(0x0)
{
	create_default_options();
	parse_options(argc, argv);

	if (COMPUTING_DEVICE_GPU == comp_dev)
	{
		set_device(id_a_dev, verbose);
	}

	if (COMPUTING_DEVICE_CPU == comp_dev)
	{
		use_padded_storage = false;
	}

	if (parameters_filename.length() == 0)
	{
		throw string("Missing filename for -p | --parameter!");
	}
	if (bodylist_filename.length() == 0)
	{
		throw string("Missing filename for -ic | --initial_conditions!");
	}

	param = new parameter(input_dir, parameters_filename, verbose);
	if (gasdisk_filename.length() > 0)
	{
		g_disk = new gas_disk(input_dir, gasdisk_filename, verbose);
		has_gas = true;
	}
}

options::~options() 
{
}

void options::print_usage()
{
	cout << "Usage: red.cuda <parameterlist>" << endl;
	cout << "Parameters:" << endl;
	cout << "     -id_dev | --id_active_device             : the id of the device which will execute the code" << endl;
	cout << "     -ups    | --use-padded-storage           : use padded storage to store data (default is false)" << endl; 
	cout << "     -n_tpb  | --n_thread-per-block           : the number of thread per block to use in kernel lunches (default is 64)" << endl;
	cout << "     -iDir   | --inputDir <directory>         : the directory containing the input files"  << endl;
	cout << "     -p      | --parameter <filename>         : the file containing the parameters of the simulation"  << endl;
	cout << "     -gd     | --gas_disk <filename>          : the file containing the parameters of the gas disk"  << endl;
	cout << "     -ic     | --initial_condition <filename> : the file containing the initial conditions"  << endl;
	cout << "     -info   | --info-filename                : the name of the file where the runtime output of the code will be stored (default is info.txt)" << endl;
	cout << "     -event  | --event-filename               : the name of the file where the details of each event will be stored (default is event.txt)" << endl;
	cout << "     -log    | --log-filename                 : the name of the file where the details of the execution of the code will be stored (default is log.txt)" << endl;
	cout << "     -result | --result-filename              : the name of the file where the simlation data for a time instance will be stored (default is result.txt" << endl;
	cout << "                                                where [...] contains data describing the integrator)" << endl;
	cout << "     -v      | --verbose                      : verbose mode" << endl;
	cout << "     -gpu    | --gpu                          : Execute the code on the graphics processing unit (GPU) (default is true)" << endl;
	cout << "     -cpu    | --cpu                          : Execute the code on the cpu if required by the user or if no GPU is installed (default is false)" << endl;
	cout << "     -h      | --help                         : print this help" << endl;
}

void options::create_default_options()
{
	id_a_dev           = 0;
	comp_dev           = COMPUTING_DEVICE_GPU;
	verbose            = false;
	use_padded_storage = false;
	n_tpb              = 64;

	ef                 = false;

	info_filename      = "info";
	event_filename     = "event";
	log_filename       = "log";
	result_filename    = "result";
}

void options::parse_options(int argc, const char** argv)
{
	int i = 1;

	while (i < argc)
	{
		string p = argv[i];

		if (     p == "--id_active_device" || p == "-id_dev")
		{
			i++;
			if (!tools::is_number(argv[i])) 
			{
				throw string("Invalid number at: " + p);
			}
			id_a_dev = atoi(argv[i]);
		}
		else if (p == "--use-padded-storage" || p == "-ups")
		{
			use_padded_storage = true;
		}
		else if (p == "--n_thread-per-block" || p == "-n_tpb")
		{
			i++;
			if (!tools::is_number(argv[i])) 
			{
				throw string("Invalid number at: " + p);
			}
			n_tpb = atoi(argv[i]);
		}
		else if (p == "--inputDir" || p == "-iDir")
		{
			i++;
			input_dir = argv[i];
			printout_dir = input_dir;
		}
		else if (p =="--parameters" || p == "-p")
		{
			i++;
			parameters_filename = argv[i];
		}
		else if (p == "--gas_disk" || p == "-gd")
		{
			i++;
			gasdisk_filename = argv[i];
		}
		else if (p == "--initial_conditions" || p == "-ic")
		{
			i++;
			bodylist_filename = argv[i];
		}
		else if (p == "--info-filename" || p == "-info")
		{
			i++;
			info_filename = argv[i];
		}
		else if (p == "--event-filename" || p == "-event")
		{
			i++;
			event_filename = argv[i];
		}
		else if (p == "--log-filename" || p == "-log")
		{
			i++;
			log_filename = argv[i];
		}
		else if (p == "--result-filename" || p == "-result")
		{
			i++;
			result_filename = argv[i];
		}
		else if (p == "--verbose" || p == "-v")
		{
			verbose = true;
		}
		else if (p == "-ef")
		{
			ef = true;
		}
		else if (p == "--cpu" || p == "-cpu")
		{
			comp_dev = COMPUTING_DEVICE_CPU;
		}
		else if (p == "--gpu" || p == "-gpu")
		{
			comp_dev = COMPUTING_DEVICE_GPU;
		}
		else if (p == "--help" || p == "-h")
		{
			print_usage();
			exit(EXIT_SUCCESS);
		}
		else
		{
			throw string("Invalid switch on command-line: " + p + ".");
		}
		i++;
	}
}

pp_disk* options::create_pp_disk()
{
	string path = file::combine_path(input_dir, bodylist_filename);
	pp_disk* ppd = new pp_disk(path, g_disk, n_tpb, use_padded_storage, comp_dev);
	if (0x0 != ppd->g_disk)
	{
		ppd->g_disk->calc(ppd->get_mass_of_star());
		//ppd->print_result_ascii(cout);
	}
	ppd->frame_center = ppd->n_bodies->frame_center = param->frame_center;

	if (0 == fabs(ppd->sim_data->y[0][0].x) && 0 == fabs(ppd->sim_data->y[0][0].y) && 0 == fabs(ppd->sim_data->y[0][0].z) && 0 == fabs(ppd->sim_data->y[1][0].x) && 0 == fabs(ppd->sim_data->y[1][0].y) && 0 == fabs(ppd->sim_data->y[1][0].z))
	{
		if (ppd->frame_center == FRAME_CENTER_BARY)
		{
			ppd->transform_to_bc(verbose);
		}
	}
	else
	{
		if (ppd->frame_center == FRAME_CENTER_ASTRO)
		{
			ppd->transform_to_ac(verbose, ppd->sim_data);
		}	
	}

	ppd->transform_time(verbose);
	ppd->transform_velocity(verbose);
	if (COMPUTING_DEVICE_GPU == comp_dev)
	{
		ppd->copy_to_device();
	}
	ppd->copy_threshold(param->thrshld);
	ppd->t = param->start_time;
	ppd->close_encounter = param->close_encounter;
	ppd->inner_steps = param->inner_steps;

	return ppd;
}

integrator* options::create_integrator(pp_disk* ppd, ttt_t dt)
{
	integrator* intgr;

	switch (param->int_type)
	{
	case INTEGRATOR_EULER:
		intgr = new euler(ppd, dt, comp_dev);
		break;
	case INTEGRATOR_RUNGEKUTTA2:
		intgr = new rungekutta2(ppd, dt, comp_dev);
		break;
	case INTEGRATOR_RUNGEKUTTA4:
		intgr = new rungekutta4(ppd, dt, param->adaptive, param->tolerance, comp_dev);
		break;
	case INTEGRATOR_RUNGEKUTTA5:
		throw string("Requested integrator is not implemented.");
		//intgr = new rungekutta5(ppd, dt, param->adaptive, param->tolerance, comp_dev);
		break;
	case INTEGRATOR_RUNGEKUTTAFEHLBERG78:
		intgr = new rungekutta8(ppd, dt, param->adaptive, param->tolerance, comp_dev);
		//intgr = new c_rungekutta8(ppd, dt, param->adaptive, param->tolerance);
		break;
	case INTEGRATOR_RUNGEKUTTANYSTROM:
		throw string("Requested integrator is not implemented.");
		//intgr = new rungekuttanystrom<9>(*f, dt, adaptive, tolerance, comp_dev);
		break;
	default:
		throw string("Requested integrator is not implemented.");
	}

	if (param->error_check_for_tp)
	{
		intgr->error_check_for_tp = true;
	}

	return intgr;
}
