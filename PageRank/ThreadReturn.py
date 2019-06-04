from threading import Thread
class ThreadReturn(Thread):
    """Clase Thread con retorno de valor"""
    def __init__(self, *args, **kwargs):
        super(ThreadReturn, self).__init__(*args, **kwargs)
        self._return = None
    def run(self):
        if self._target is not None:
            self._return = self._target(*self._args, **self._kwargs)
    def join(self, *args, **kwargs):
        super(ThreadReturn, self).join(*args, **kwargs)
        return self._return

