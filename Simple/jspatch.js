defineClass("JSPatchViewController",{
	//instance method definitions
	tableView_didSelectRowAtIndexPath: function(tableView,indexPath)
	{
		var row = indexPath.row()
		if (self.dataSource().length > row) 
		{
			//加上判断越界的逻辑
			// var content = self.dataSource()[row];
			var ctrl = CGViewController.alloc().init();
			self.navigationController().pushViewController(ctrl);
		}

	}
})